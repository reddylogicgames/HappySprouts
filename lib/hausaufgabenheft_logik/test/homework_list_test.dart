// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:test/test.dart';

import 'create_homework_util.dart';
import 'test_data/homeworks.dart';

void main() {
  group('List<HomeworkReadModel>', () {
    group('sort with SubjectSmallestDateAndTitleSort', () {
      testSubjectSort(
        'firstly sorts by Subject',
        (homeworks) => homeworks.sortWith(SubjectSmallestDateAndTitleSort()),
      );

      testDateSort(
        'then by date, only if the subject of two homeworks are the same',
        (homeworks) => homeworks.sortWith(SubjectSmallestDateAndTitleSort()),
      );

      testTitleSort(
        'lastly sorts by title, only if subject and date are the same',
        (homeworks) => homeworks.sortWith(SubjectSmallestDateAndTitleSort()),
      );

      testSort(
        'integration test',
        unsorted: unsortedHomework,
        sorted: sortedHomeworksForSortBySubjectDateTitle,
        sort:
            (homeworks) =>
                homeworks.sortWith(SubjectSmallestDateAndTitleSort()),
      );
    });
    group('sort with SmallestDateSubjectAndTitleSort', () {
      testDateSort(
        'firstly sorts by Date',
        (homeworks) => homeworks.sortWith(SmallestDateSubjectAndTitleSort()),
      );

      testSubjectSort(
        'then by Subject, only if the date of two homeworks are the same',
        (homeworks) => homeworks.sortWith(SmallestDateSubjectAndTitleSort()),
      );

      testTitleSort(
        'lastly by title, only if the date and subject are the same',
        (homeworks) => homeworks.sortWith(SmallestDateSubjectAndTitleSort()),
      );

      testSort(
        'integration test',
        unsorted: unsortedHomework,
        sorted: sortedHomeworksForSortByDateSubjectTitle,
        sort:
            (homeworks) =>
                homeworks.sortWith(SmallestDateSubjectAndTitleSort()),
      );

      final sorted = List<StudentHomeworkReadModel>.generate(
        15,
        (i) => createHomework(
          todoDate: const Date(year: 2019, month: 02, day: 03),
          subject: 'Subject',
          title: '$i',
        ),
      );
      final unsorted = List<StudentHomeworkReadModel>.from(sorted)..shuffle();
      testSort(
        'does sort titles starting with numbers by their value',
        unsorted: unsorted,
        sorted: sorted,
        sort: (hw) => hw.sortWith(SmallestDateSubjectAndTitleSort()),
        skip: true,
      );
    });
  });
  test('getDistinctSubjects', () {
    var mathe = Subject('Mathe', abbreviation: 'Ma');
    var englisch = Subject('Englisch', abbreviation: 'En');
    var deutsch = Subject('Deutsch', abbreviation: 'De');
    final subjects = [mathe, englisch, mathe, mathe, deutsch];
    final homeworks = [
      for (final subject in subjects)
        createHomework(
          subject: subject.name,
          abbreviation: subject.abbreviation,
        ),
    ];
    final homeworkList = homeworks.toIList();

    final result = homeworkList.getDistinctOrderedSubjects();

    expect(result, [mathe, englisch, deutsch]);
  });
}

void testDateSort(String title, ListCallback sort) => testSort(
  title,
  unsorted: [haDate_23_02_19, haDate_02_01_19, haDate_30_2_2020],
  sorted: [haDate_02_01_19, haDate_23_02_19, haDate_30_2_2020],
  sort: sort,
);

void testSort(
  String title, {
  required List<StudentHomeworkReadModel> unsorted,
  required List<StudentHomeworkReadModel> sorted,
  required ListCallback sort,
  bool skip = false,
}) {
  test(title, () {
    final actualSorted = sort(unsorted.toIList());
    expect(actualSorted.toList(), sorted);
  }, skip: skip);
}

void testSubjectSort(String title, ListCallback sort) => testSort(
  title,
  unsorted: [haSubjectInformatics, haSubjectEnglish, haSubjectMaths],
  sorted: [haSubjectEnglish, haSubjectInformatics, haSubjectMaths],
  sort: sort,
);

void testTitleSort(String title, ListCallback sort) => testSort(
  title,
  unsorted: [haTitleBlatt, haTitleAufgaben, haTitleClown],
  sorted: [haTitleAufgaben, haTitleBlatt, haTitleClown],
  sort: sort,
);

typedef ListCallback =
    IList<StudentHomeworkReadModel> Function(IList<StudentHomeworkReadModel>);
