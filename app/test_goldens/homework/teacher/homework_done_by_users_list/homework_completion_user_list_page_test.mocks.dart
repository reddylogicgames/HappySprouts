// Mocks generated by Mockito 5.4.2 from annotations
// in sharezone/test_goldens/homework/teacher/homework_done_by_users_list/homework_completion_user_list_page_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i7;

import 'package:clock/clock.dart' as _i3;
import 'package:common_domain_models/common_domain_models.dart' as _i6;
import 'package:mockito/mockito.dart' as _i1;
import 'package:sharezone/homework/teacher/homework_done_by_users_list/homework_completion_user_list_bloc.dart'
    as _i2;
import 'package:sharezone/homework/teacher/homework_done_by_users_list/homework_completion_user_list_bloc_factory.dart'
    as _i5;
import 'package:sharezone/homework/teacher/homework_done_by_users_list/user_has_completed_homework_view.dart'
    as _i8;
import 'package:sharezone/sharezone_plus/subscription_service/subscription_flag.dart'
    as _i4;
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart'
    as _i9;
import 'package:user/user.dart' as _i10;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeHomeworkCompletionUserListBloc_0 extends _i1.SmartFake
    implements _i2.HomeworkCompletionUserListBloc {
  _FakeHomeworkCompletionUserListBloc_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeClock_1 extends _i1.SmartFake implements _i3.Clock {
  _FakeClock_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeSubscriptionEnabledFlag_2 extends _i1.SmartFake
    implements _i4.SubscriptionEnabledFlag {
  _FakeSubscriptionEnabledFlag_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [HomeworkCompletionUserListBlocFactory].
///
/// See the documentation for Mockito's code generation for more information.
class MockHomeworkCompletionUserListBlocFactory extends _i1.Mock
    implements _i5.HomeworkCompletionUserListBlocFactory {
  @override
  _i2.HomeworkCompletionUserListBloc create(_i6.HomeworkId? id) =>
      (super.noSuchMethod(
        Invocation.method(
          #create,
          [id],
        ),
        returnValue: _FakeHomeworkCompletionUserListBloc_0(
          this,
          Invocation.method(
            #create,
            [id],
          ),
        ),
        returnValueForMissingStub: _FakeHomeworkCompletionUserListBloc_0(
          this,
          Invocation.method(
            #create,
            [id],
          ),
        ),
      ) as _i2.HomeworkCompletionUserListBloc);
  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [HomeworkCompletionUserListBloc].
///
/// See the documentation for Mockito's code generation for more information.
class MockHomeworkCompletionUserListBloc extends _i1.Mock
    implements _i2.HomeworkCompletionUserListBloc {
  @override
  _i7.Stream<List<_i8.UserHasCompletedHomeworkView>> get userViews =>
      (super.noSuchMethod(
        Invocation.getter(#userViews),
        returnValue: _i7.Stream<List<_i8.UserHasCompletedHomeworkView>>.empty(),
        returnValueForMissingStub:
            _i7.Stream<List<_i8.UserHasCompletedHomeworkView>>.empty(),
      ) as _i7.Stream<List<_i8.UserHasCompletedHomeworkView>>);
  @override
  void logOpenHomeworkDoneByUsersList() => super.noSuchMethod(
        Invocation.method(
          #logOpenHomeworkDoneByUsersList,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [SubscriptionService].
///
/// See the documentation for Mockito's code generation for more information.
class MockSubscriptionService extends _i1.Mock
    implements _i9.SubscriptionService {
  @override
  _i7.Stream<_i10.AppUser?> get user => (super.noSuchMethod(
        Invocation.getter(#user),
        returnValue: _i7.Stream<_i10.AppUser?>.empty(),
        returnValueForMissingStub: _i7.Stream<_i10.AppUser?>.empty(),
      ) as _i7.Stream<_i10.AppUser?>);
  @override
  _i3.Clock get clock => (super.noSuchMethod(
        Invocation.getter(#clock),
        returnValue: _FakeClock_1(
          this,
          Invocation.getter(#clock),
        ),
        returnValueForMissingStub: _FakeClock_1(
          this,
          Invocation.getter(#clock),
        ),
      ) as _i3.Clock);
  @override
  _i4.SubscriptionEnabledFlag get isSubscriptionEnabledFlag =>
      (super.noSuchMethod(
        Invocation.getter(#isSubscriptionEnabledFlag),
        returnValue: _FakeSubscriptionEnabledFlag_2(
          this,
          Invocation.getter(#isSubscriptionEnabledFlag),
        ),
        returnValueForMissingStub: _FakeSubscriptionEnabledFlag_2(
          this,
          Invocation.getter(#isSubscriptionEnabledFlag),
        ),
      ) as _i4.SubscriptionEnabledFlag);
  @override
  bool isSubscriptionActive([_i10.AppUser? appUser]) => (super.noSuchMethod(
        Invocation.method(
          #isSubscriptionActive,
          [appUser],
        ),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
  @override
  _i7.Stream<bool> isSubscriptionActiveStream() => (super.noSuchMethod(
        Invocation.method(
          #isSubscriptionActiveStream,
          [],
        ),
        returnValue: _i7.Stream<bool>.empty(),
        returnValueForMissingStub: _i7.Stream<bool>.empty(),
      ) as _i7.Stream<bool>);
  @override
  bool hasFeatureUnlocked(_i9.SharezonePlusFeature? feature) =>
      (super.noSuchMethod(
        Invocation.method(
          #hasFeatureUnlocked,
          [feature],
        ),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
  @override
  _i7.Stream<bool> hasFeatureUnlockedStream(
          _i9.SharezonePlusFeature? feature) =>
      (super.noSuchMethod(
        Invocation.method(
          #hasFeatureUnlockedStream,
          [feature],
        ),
        returnValue: _i7.Stream<bool>.empty(),
        returnValueForMissingStub: _i7.Stream<bool>.empty(),
      ) as _i7.Stream<bool>);
}
