// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:io';

import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:path/path.dart' as path;
import 'package:sz_repo_cli/src/common/common.dart';

/// Replaces goldens with the ones provided by a failed GitHub golden Action.
///
/// We currently have to generate golden files on a mac. Developers on other
/// platforms will have to upload their wrong golden files and then download the
/// golden files that were generated in the failing GitHub Action job and place
/// them somewhere in a folder in this repo.
///
/// The files from GitHub Actions are named in the following pattern:
/// * foo_testImage.png (The image generated by golden job)
/// * foo_masterImage.png (The image that was checked into the repo)
/// * foo_isolatedDiff.png
/// * foo_maskedDiff.png
///
/// This command will replace all local goldens with the ones from GitHub
/// Actions by taking the `_testImage.png` files, removing the `_testImage` part
/// and replacing the old golden files with the same name.
class ReplaceGoldens extends CommandBase {
  ReplaceGoldens(super.context);

  @override
  String get description =>
      'Replaces goldens with the ones provided by a failed GitHub golden Action.\n'
      'To use this command, drop the golden files from the GitHub Actions job somewhere in a folder in this repo.\n'
      'Then run this command. It will replace all local goldens with the ones from GitHub Actions.';

  @override
  String get name => 'replace-goldens';

  @override
  Future<void> run() async {
    final files = Glob('**/**testImage.png')
        .listSync(root: repo.location.path)
        .whereType<File>();

    for (var file in files) {
      final fileName = path.basename(file.path);
      final newFileName = fileName.replaceAll('_testImage', '');

      // O(shit) - very inefficient.
      final oldGolden = Glob("**/**$newFileName")
          .listSync(root: repo.location.path)
          .whereType<File>()
          .single;

      file.copySync(oldGolden.path);
    }
  }
}
