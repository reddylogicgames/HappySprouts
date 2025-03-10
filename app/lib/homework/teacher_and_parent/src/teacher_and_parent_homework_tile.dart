// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';
import 'package:flutter/material.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik_lehrer.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/homework/homework_details/homework_details.dart';
import 'package:sharezone/homework/shared/homework_tile_template.dart';
import 'package:sharezone/homework/shared/shared.dart';
import 'package:sharezone/homework/teacher_and_parent/homework_done_by_users_list/homework_completion_user_list_page.dart';
import 'package:sharezone/submissions/homework_list_submissions_page.dart';
import 'package:sharezone/util/navigation_service.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:user/user.dart';

class TeacherAndParentHomeworkTile extends StatelessWidget {
  final TeacherAndParentHomeworkView homework;

  const TeacherAndParentHomeworkTile({super.key, required this.homework});

  @override
  Widget build(BuildContext context) {
    final isTeacher = Provider.of<TypeOfUser>(context).isTeacher;

    return HomeworkTileTemplate(
      isCompleted: false,
      title: homework.title,
      courseName: homework.subject,
      courseAbbreviation: homework.abbreviation,
      courseColor: Color(homework.subjectColor.value),
      todoDate: homework.todoDate,
      todoDateColor:
          homework.colorDate
              ? Colors.redAccent
              : Theme.of(context).textTheme.bodyMedium!.color,
      onTap: () => _showHomeworkDetails(context),
      trailing:
          isTeacher
              ? homework.withSubmissions
                  ? _SubmissionsCounter(
                    nrOfSubmitters: homework.nrOfStudentsCompletedOrSubmitted,
                    hasPermissionsToSeeSubmissions:
                        homework.canViewCompletionOrSubmissionList,
                    homeworkId: homework.id,
                  )
                  : _DoneHomeworksCounter(
                    nrOfDoneHomeworks:
                        homework.nrOfStudentsCompletedOrSubmitted,
                    hasPermissionsToSeeDoneHomeworks:
                        homework.canViewCompletionOrSubmissionList,
                    homeworkId: homework.id,
                  )
              : const SizedBox.shrink(),
      onLongPress:
          () => handleHomeworkTileLongPress(context, homeworkId: homework.id),
      key: Key('${homework.id}'),
    );
  }

  Future<bool> _showHomeworkDetails(BuildContext context) async {
    return pushWithDefault<bool>(
      context,
      HomeworkDetails.loadId('${homework.id}'),
      defaultValue: false,
      name: HomeworkDetails.tag,
    );
  }
}

class _SubmissionsCounter extends StatelessWidget {
  final int nrOfSubmitters;
  final bool hasPermissionsToSeeSubmissions;
  final HomeworkId homeworkId;

  const _SubmissionsCounter({
    required this.nrOfSubmitters,
    required this.hasPermissionsToSeeSubmissions,
    required this.homeworkId,
  });

  @override
  Widget build(BuildContext context) {
    return _TrailingCounterIconButton(
      counterValue: nrOfSubmitters,
      onPressed: () {
        if (!hasPermissionsToSeeSubmissions) {
          showTeacherMustBeAdminDialogToViewSubmissions(context);
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => HomeworkUserSubmissionsPage(homeworkId: '$homeworkId'),
          ),
        );
      },
    );
  }
}

void showTeacherMustBeAdminDialogToViewSubmissions(BuildContext context) {
  showLeftRightAdaptiveDialog(
    context: context,
    left: AdaptiveDialogAction.ok,
    title: 'Keine Berechtigung',
    content: const Text(
      'Eine Lehrkraft darf aus Sicherheitsgründen nur mit Admin-Rechten in der jeweiligen Gruppe die Abgabe anschauen.\n\nAnsonsten könnte jeder Schüler einen neuen Account als Lehrkraft erstellen und der Gruppe beitreten, um die Abgabe der anderen Mitschüler anzuschauen.',
    ),
  );
}

class _DoneHomeworksCounter extends StatelessWidget {
  final int nrOfDoneHomeworks;
  final bool hasPermissionsToSeeDoneHomeworks;
  final HomeworkId homeworkId;

  const _DoneHomeworksCounter({
    required this.nrOfDoneHomeworks,
    required this.hasPermissionsToSeeDoneHomeworks,
    required this.homeworkId,
  });

  @override
  Widget build(BuildContext context) {
    return _TrailingCounterIconButton(
      counterValue: nrOfDoneHomeworks,
      onPressed: () {
        if (!hasPermissionsToSeeDoneHomeworks) {
          _showTeacherMustBeAdminDialogToViewCompletionList(context);
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => HomeworkCompletionUserListPage(homeworkId: homeworkId),
          ),
        );
      },
    );
  }
}

void _showTeacherMustBeAdminDialogToViewCompletionList(BuildContext context) {
  showLeftRightAdaptiveDialog(
    context: context,
    left: AdaptiveDialogAction.ok,
    title: 'Keine Berechtigung',
    content: const Text(
      'Eine Lehrkraft darf aus Sicherheitsgründen nur mit Admin-Rechten in der jeweiligen Gruppe die Erledigt-Liste anschauen.\n\nAnsonsten könnte jeder Schüler einen neuen Account als Lehrkraft erstellen und der Gruppe beitreten, um einzusehen, welche Mitschüler die Hausaufgaben bereits erledigt haben.',
    ),
  );
}

class _TrailingCounterIconButton extends StatelessWidget {
  final int counterValue;
  final VoidCallback onPressed;

  const _TrailingCounterIconButton({
    required this.counterValue,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 50,
      icon: Chip(label: Text('$counterValue')),
      onPressed: onPressed,
    );
  }
}
