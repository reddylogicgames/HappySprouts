// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/onboarding/group_onboarding/logic/group_onboarding_bloc.dart';
import 'package:sharezone/onboarding/group_onboarding/pages/create_schoolclass.dart';
import 'package:sharezone/onboarding/group_onboarding/pages/group_onboarding_page_template.dart';
import 'package:sharezone/onboarding/sign_up/sign_up_page.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import '../widgets/text_button.dart';
import 'create_courses.dart';

class GroupOnboardingIsClassTeacher extends StatelessWidget {
  static const tag = 'onboarding-is-class-teacher-page';

  const GroupOnboardingIsClassTeacher({super.key});

  @override
  Widget build(BuildContext context) {
    return const GroupOnboardingPageTemplate(
      title: "Leitest du eine Klasse? (Klassenlehrer)",
      bottomNavigationBar: OnboardingNavigationBar(),
      children: [_ClassTeacherButton(), _CourseTeacherButton()],
    );
  }
}

class _ClassTeacherButton extends StatelessWidget {
  const _ClassTeacherButton();

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<GroupOnboardingBloc>(context);
    return GroupOnboardingTextButton(
      text: "Ja, ich möchte eine Klasse erstellen",
      onTap: () {
        bloc.setTeacherType(TeacherType.classTeacher);
        Navigator.push(
          context,
          FadeRoute(
            child: const GroupOnboardingCreateSchoolClass(),
            tag: GroupOnboardingCreateSchoolClass.tag,
          ),
        );
      },
    );
  }
}

class _CourseTeacherButton extends StatelessWidget {
  const _CourseTeacherButton();

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<GroupOnboardingBloc>(context);
    return GroupOnboardingTextButton(
      text: "Nein, ich möchte nur Kurse erstellen",
      onTap: () {
        bloc.setTeacherType(TeacherType.courseTeacher);
        Navigator.push(
          context,
          FadeRoute(
            child: const GroupOnboardingCreateCourse(schoolClassId: null),
            tag: GroupOnboardingCreateCourse.tag,
          ),
        );
      },
    );
  }
}
