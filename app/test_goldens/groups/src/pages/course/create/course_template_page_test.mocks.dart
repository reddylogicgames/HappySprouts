// Mocks generated by Mockito 5.4.4 from annotations
// in sharezone/test_goldens/groups/src/pages/course/create/course_template_page_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:common_domain_models/common_domain_models.dart' as _i4;
import 'package:group_domain_models/group_domain_models.dart' as _i6;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i8;
import 'package:sharezone/groups/src/pages/course/create/bloc/course_create_bloc.dart'
    as _i2;
import 'package:sharezone/groups/src/pages/course/create/bloc/course_create_bloc_factory.dart'
    as _i5;
import 'package:sharezone/groups/src/pages/course/create/models/course_template.dart'
    as _i7;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeCourseCreateBloc_0 extends _i1.SmartFake
    implements _i2.CourseCreateBloc {
  _FakeCourseCreateBloc_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeStreamTransformer_1<S, T> extends _i1.SmartFake
    implements _i3.StreamTransformer<S, T> {
  _FakeStreamTransformer_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeCourseId_2 extends _i1.SmartFake implements _i4.CourseId {
  _FakeCourseId_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [CourseCreateBlocFactory].
///
/// See the documentation for Mockito's code generation for more information.
class MockCourseCreateBlocFactory extends _i1.Mock
    implements _i5.CourseCreateBlocFactory {
  @override
  _i2.CourseCreateBloc create({_i4.SchoolClassId? schoolClassId}) =>
      (super.noSuchMethod(
        Invocation.method(
          #create,
          [],
          {#schoolClassId: schoolClassId},
        ),
        returnValue: _FakeCourseCreateBloc_0(
          this,
          Invocation.method(
            #create,
            [],
            {#schoolClassId: schoolClassId},
          ),
        ),
        returnValueForMissingStub: _FakeCourseCreateBloc_0(
          this,
          Invocation.method(
            #create,
            [],
            {#schoolClassId: schoolClassId},
          ),
        ),
      ) as _i2.CourseCreateBloc);
  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [CourseCreateBloc].
///
/// See the documentation for Mockito's code generation for more information.
class MockCourseCreateBloc extends _i1.Mock implements _i2.CourseCreateBloc {
  @override
  set schoolClassId(_i4.SchoolClassId? _schoolClassId) => super.noSuchMethod(
        Invocation.setter(
          #schoolClassId,
          _schoolClassId,
        ),
        returnValueForMissingStub: null,
      );
  @override
  set initialCourse(_i6.Course? _initialCourse) => super.noSuchMethod(
        Invocation.setter(
          #initialCourse,
          _initialCourse,
        ),
        returnValueForMissingStub: null,
      );
  @override
  bool get hasSchoolClassId => (super.noSuchMethod(
        Invocation.getter(#hasSchoolClassId),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
  @override
  _i3.Stream<String> get subject => (super.noSuchMethod(
        Invocation.getter(#subject),
        returnValue: _i3.Stream<String>.empty(),
        returnValueForMissingStub: _i3.Stream<String>.empty(),
      ) as _i3.Stream<String>);
  @override
  _i3.Stream<List<(_i4.SchoolClassId, String)>?> get myAdminSchoolClasses =>
      (super.noSuchMethod(
        Invocation.getter(#myAdminSchoolClasses),
        returnValue: _i3.Stream<List<(_i4.SchoolClassId, String)>?>.empty(),
        returnValueForMissingStub:
            _i3.Stream<List<(_i4.SchoolClassId, String)>?>.empty(),
      ) as _i3.Stream<List<(_i4.SchoolClassId, String)>?>);
  @override
  dynamic Function(String) get changeName => (super.noSuchMethod(
        Invocation.getter(#changeName),
        returnValue: (String __p0) => null,
        returnValueForMissingStub: (String __p0) => null,
      ) as dynamic Function(String));
  @override
  dynamic Function(String) get changeSubject => (super.noSuchMethod(
        Invocation.getter(#changeSubject),
        returnValue: (String __p0) => null,
        returnValueForMissingStub: (String __p0) => null,
      ) as dynamic Function(String));
  @override
  dynamic Function(String) get changeAbbreviation => (super.noSuchMethod(
        Invocation.getter(#changeAbbreviation),
        returnValue: (String __p0) => null,
        returnValueForMissingStub: (String __p0) => null,
      ) as dynamic Function(String));
  @override
  _i3.StreamTransformer<String, String> get validateSubject =>
      (super.noSuchMethod(
        Invocation.getter(#validateSubject),
        returnValue: _FakeStreamTransformer_1<String, String>(
          this,
          Invocation.getter(#validateSubject),
        ),
        returnValueForMissingStub: _FakeStreamTransformer_1<String, String>(
          this,
          Invocation.getter(#validateSubject),
        ),
      ) as _i3.StreamTransformer<String, String>);
  @override
  void loadAdminSchoolClasses() => super.noSuchMethod(
        Invocation.method(
          #loadAdminSchoolClasses,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void setInitialTemplate(_i7.CourseTemplate? template) => super.noSuchMethod(
        Invocation.method(
          #setInitialTemplate,
          [template],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void setSchoolClassId(_i4.SchoolClassId? schoolClassId) => super.noSuchMethod(
        Invocation.method(
          #setSchoolClassId,
          [schoolClassId],
        ),
        returnValueForMissingStub: null,
      );
  @override
  bool hasUserEditInput() => (super.noSuchMethod(
        Invocation.method(
          #hasUserEditInput,
          [],
        ),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
  @override
  _i3.Future<(_i4.CourseId, String)> submitCourse() => (super.noSuchMethod(
        Invocation.method(
          #submitCourse,
          [],
        ),
        returnValue: _i3.Future<(_i4.CourseId, String)>.value((
          _FakeCourseId_2(
            this,
            Invocation.method(
              #submitCourse,
              [],
            ),
          ),
          _i8.dummyValue<String>(
            this,
            Invocation.method(
              #submitCourse,
              [],
            ),
          )
        )),
        returnValueForMissingStub: _i3.Future<(_i4.CourseId, String)>.value((
          _FakeCourseId_2(
            this,
            Invocation.method(
              #submitCourse,
              [],
            ),
          ),
          _i8.dummyValue<String>(
            this,
            Invocation.method(
              #submitCourse,
              [],
            ),
          )
        )),
      ) as _i3.Future<(_i4.CourseId, String)>);
  @override
  _i3.Future<(_i4.CourseId, String)> submitWithCourseTemplate(
          _i7.CourseTemplate? courseTemplate) =>
      (super.noSuchMethod(
        Invocation.method(
          #submitWithCourseTemplate,
          [courseTemplate],
        ),
        returnValue: _i3.Future<(_i4.CourseId, String)>.value((
          _FakeCourseId_2(
            this,
            Invocation.method(
              #submitWithCourseTemplate,
              [courseTemplate],
            ),
          ),
          _i8.dummyValue<String>(
            this,
            Invocation.method(
              #submitWithCourseTemplate,
              [courseTemplate],
            ),
          )
        )),
        returnValueForMissingStub: _i3.Future<(_i4.CourseId, String)>.value((
          _FakeCourseId_2(
            this,
            Invocation.method(
              #submitWithCourseTemplate,
              [courseTemplate],
            ),
          ),
          _i8.dummyValue<String>(
            this,
            Invocation.method(
              #submitWithCourseTemplate,
              [courseTemplate],
            ),
          )
        )),
      ) as _i3.Future<(_i4.CourseId, String)>);
  @override
  _i3.Future<void> deleteCourse(_i4.CourseId? courseId) => (super.noSuchMethod(
        Invocation.method(
          #deleteCourse,
          [courseId],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  bool isCourseTemplateAlreadyAdded(_i7.CourseTemplate? courseTemplate) =>
      (super.noSuchMethod(
        Invocation.method(
          #isCourseTemplateAlreadyAdded,
          [courseTemplate],
        ),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
}