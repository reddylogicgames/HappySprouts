// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:io';

import 'package:process_runner/process_runner.dart';
import 'package:sz_repo_cli/src/common/common.dart';
import 'package:path/path.dart' as path;

final _androidStages = ['stable', 'beta'];

/// The different flavors of the Android app that support deployment.
final _androidFlavors = ['prod'];

class DeployAndroidCommand extends CommandBase {
  DeployAndroidCommand(super.context) {
    argParser
      ..addOption(
        releaseStageOptionName,
        abbr: 's',
        allowed: _androidStages,
        help:
            'The stage to deploy to. The "stable" and "beta" stage is used for '
            'Play Store releases.',
        defaultsTo: 'stable',
      )
      ..addOption(
        whatsNewOptionName,
        help:
            "Release notes either for the Play Store submission. Describe what's new in this version of your app, such as new features, improvements, and bug fixes. The string should not exceed 500 characters when you publish the Play Store. Example usage: --whats-new 'Bug fixes and performance improvements.'",
      )
      ..addOption(
        flavorOptionName,
        allowed: _androidFlavors,
        help: 'The flavor to build for. Only the "prod" flavor is supported.',
        defaultsTo: 'prod',
      )
      ..addOption(
        rolloutPercentageOptionName,
        help:
            'The percentage (between 0.0 - 1.0) of the user fraction when uploading to the rollout track (setting to 1 will complete the rollout).',
        defaultsTo: '1.0',
      );
  }

  static const rolloutPercentageOptionName = 'rollout-percentage';
  static const releaseStageOptionName = 'stage';
  static const flavorOptionName = 'flavor';
  static const whatsNewOptionName = 'whats-new';

  static const _changelogDirectory =
      'android/fastlane/metadata/android/de-DE/changelogs';
  static const _defaultChangelogFileName = 'default.txt';
  static const _changelogFilePath =
      '$_changelogDirectory/$_defaultChangelogFileName';

  @override
  String get description =>
      'Deploys the Sharezone Android app to the Play Store. Automatically bumps the build number and builds the app. Codemagic CLI tools & Fastlane are required.';

  @override
  String get name => 'android';

  @override
  Future<void> run() async {
    _throwIfFlavorIsNotSupportForDeployment();
    _checkIfGooglePlayCredentialsAreValid(processRunner);

    // Is used so that runProcess commands print the command that was run. Right
    // now this can't be done via an argument.
    //
    // This workaround should be addressed in the future.
    isVerbose = true;

    final buildNumber = await _getNextBuildNumber(processRunner);
    await _buildApp(buildNumber: buildNumber);
    await _publish();

    stdout.writeln('Deployment finished 🎉 ');
  }

  void _throwIfFlavorIsNotSupportForDeployment() {
    final flavor = argResults![flavorOptionName] as String;
    if (flavor != 'prod') {
      throw Exception(
        'Only the "prod" flavor is supported for Android deployment.',
      );
    }
  }

  /// Checks if Fastlane can establish a connection to Google Play.
  ///
  /// See https://docs.fastlane.tools/actions/validate_play_store_json_key
  Future<void> _checkIfGooglePlayCredentialsAreValid(
    ProcessRunner processRunner,
  ) async {
    await processRunner.run(
      ['fastlane', 'run', 'validate_play_store_json_key'],
      workingDirectory: fileSystem.directory(
        path.join(repo.sharezoneFlutterApp.location.path, 'android'),
      ),
    );
  }

  Future<int> _getNextBuildNumber(ProcessRunner processRunner) async {
    final latestBuildNumber = await _getLatestBuildNumberFromGooglePlay(
      processRunner,
    );
    final nextBuildNumber = latestBuildNumber + 1;
    stdout.writeln('Next build number: $nextBuildNumber');
    return nextBuildNumber;
  }

  /// Returns the latest build number from Google Play across all tracks.
  Future<int> _getLatestBuildNumberFromGooglePlay(
    ProcessRunner processRunner,
  ) async {
    try {
      const packageName = 'de.codingbrain.sharezone';
      final result = await processRunner.run([
        'google-play',
        'get-latest-build-number',
        '--package-name',
        packageName,
      ]);
      return int.parse(result.stdout);
    } catch (e) {
      throw Exception('Failed to get latest build number from Google Play: $e');
    }
  }

  Future<void> _buildApp({required int buildNumber}) async {
    try {
      final flavor = argResults![flavorOptionName] as String;
      final stage = argResults![releaseStageOptionName] as String;
      await processRunner.runCommand([
        'dart',
        'run',
        'sz_repo_cli',
        'build',
        'app',
        'android',
        '--flavor',
        flavor,
        '--stage',
        stage,
        '--build-number',
        '$buildNumber',
      ], workingDirectory: repo.sharezoneCiCdTool.location);
    } catch (e) {
      throw Exception('Failed to build Android app: $e');
    }
  }

  Future<void> _publish() async {
    try {
      await _setChangelog();

      final rolloutPercentage =
          argResults![rolloutPercentageOptionName] as String;
      _printRolloutPercentage(rolloutPercentage);

      await _uploadToGooglePlay(
        processRunner,
        track: _getGooglePlayTrackFromStage(),
        rollout: rolloutPercentage,
      );
    } finally {
      await _removeChangelogFile();
    }
  }

  void _printRolloutPercentage(String rolloutPercentage) {
    final rolloutPercentageDouble = double.parse(rolloutPercentage);
    stdout.writeln(
      'This release will be rolled out to: ${rolloutPercentageDouble * 100}% of users.}',
    );
    stdout.writeln(
      'You can later change the rollout percentage in the Play Store Console: Go to "Production" (or Open testing or Closed Testing) -> "Releases"',
    );
  }

  Future<void> _setChangelog() async {
    final whatsNew = argResults![whatsNewOptionName] as String?;
    if (whatsNew == null) {
      stdout.writeln('No changelog given. Skipping.');
      return;
    }
    final changelogFile = repo.sharezoneFlutterApp.location.childFile(
      _changelogFilePath,
    );

    // Create folder, if it doesn't exist.
    await changelogFile.parent.create(recursive: true);

    // Write changelog into file. Fastlane will pick it up automatically.
    //
    // See: https://docs.fastlane.tools/actions/upload_to_play_store/#changelogs-whats-new
    await changelogFile.writeAsString(whatsNew);
  }

  String _getGooglePlayTrackFromStage() {
    final stage = argResults![releaseStageOptionName] as String;
    switch (stage) {
      case 'stable':
        return 'production';
      case 'beta':
        return 'beta';
      default:
        throw Exception('Unknown stage: $stage');
    }
  }

  Future<void> _uploadToGooglePlay(
    ProcessRunner processRunner, {
    required String track,
    required String rollout,
  }) async {
    await processRunner.run(
      ['fastlane', 'deploy'],
      workingDirectory: repo.sharezoneFlutterApp.location.childDirectory(
        'android',
      ),
      addedEnvironment: {
        // Sets the number of retries for uploading the app bundle to Google
        // Play. This is needed because sometimes the upload fails for unknown
        // reasons.
        //
        // See: https://github.com/fastlane/fastlane/issues/21507#issuecomment-1723116829
        'TRACK': track,
        'ROLLOUT': rollout,
        'SUPPLY_UPLOAD_MAX_RETRIES': '5',
      },
    );
  }

  Future<void> _removeChangelogFile() async {
    final changelogFile = repo.sharezoneFlutterApp.location.childFile(
      _changelogFilePath,
    );
    if (await changelogFile.exists()) {
      await changelogFile.delete();
    }
  }
}
