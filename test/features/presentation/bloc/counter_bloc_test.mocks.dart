// Mocks generated by Mockito 5.4.5 from annotations
// in practice_app/test/features/presentation/bloc/counter_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i7;

import 'package:bloc/bloc.dart' as _i8;
import 'package:dartz/dartz.dart' as _i4;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i6;
import 'package:practice_app/core/error/failures.dart' as _i9;
import 'package:practice_app/core/usecase/usecase.dart' as _i11;
import 'package:practice_app/features/counter/domain/entities/counter.dart'
    as _i10;
import 'package:practice_app/features/counter/domain/repositories/counter_repository.dart'
    as _i3;
import 'package:practice_app/features/counter/domain/usecases/get_counter.dart'
    as _i2;
import 'package:practice_app/features/counter/presentation/bloc/counter_bloc.dart'
    as _i5;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeGetCounter_0 extends _i1.SmartFake implements _i2.GetCounter {
  _FakeGetCounter_0(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeCounterRepository_1 extends _i1.SmartFake
    implements _i3.CounterRepository {
  _FakeCounterRepository_1(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeEither_2<L, R> extends _i1.SmartFake implements _i4.Either<L, R> {
  _FakeEither_2(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

/// A class which mocks [CounterBloc].
///
/// See the documentation for Mockito's code generation for more information.
class MockCounterBloc extends _i1.Mock implements _i5.CounterBloc {
  MockCounterBloc() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.GetCounter get getCounter =>
      (super.noSuchMethod(
            Invocation.getter(#getCounter),
            returnValue: _FakeGetCounter_0(
              this,
              Invocation.getter(#getCounter),
            ),
          )
          as _i2.GetCounter);

  @override
  _i5.CounterState get state =>
      (super.noSuchMethod(
            Invocation.getter(#state),
            returnValue: _i6.dummyValue<_i5.CounterState>(
              this,
              Invocation.getter(#state),
            ),
          )
          as _i5.CounterState);

  @override
  _i7.Stream<_i5.CounterState> get stream =>
      (super.noSuchMethod(
            Invocation.getter(#stream),
            returnValue: _i7.Stream<_i5.CounterState>.empty(),
          )
          as _i7.Stream<_i5.CounterState>);

  @override
  bool get isClosed =>
      (super.noSuchMethod(Invocation.getter(#isClosed), returnValue: false)
          as bool);

  @override
  void add(_i5.CounterEvent? event) => super.noSuchMethod(
    Invocation.method(#add, [event]),
    returnValueForMissingStub: null,
  );

  @override
  void onEvent(_i5.CounterEvent? event) => super.noSuchMethod(
    Invocation.method(#onEvent, [event]),
    returnValueForMissingStub: null,
  );

  @override
  void emit(_i5.CounterState? state) => super.noSuchMethod(
    Invocation.method(#emit, [state]),
    returnValueForMissingStub: null,
  );

  @override
  void on<E extends _i5.CounterEvent>(
    _i8.EventHandler<E, _i5.CounterState>? handler, {
    _i8.EventTransformer<E>? transformer,
  }) => super.noSuchMethod(
    Invocation.method(#on, [handler], {#transformer: transformer}),
    returnValueForMissingStub: null,
  );

  @override
  void onTransition(
    _i8.Transition<_i5.CounterEvent, _i5.CounterState>? transition,
  ) => super.noSuchMethod(
    Invocation.method(#onTransition, [transition]),
    returnValueForMissingStub: null,
  );

  @override
  _i7.Future<void> close() =>
      (super.noSuchMethod(
            Invocation.method(#close, []),
            returnValue: _i7.Future<void>.value(),
            returnValueForMissingStub: _i7.Future<void>.value(),
          )
          as _i7.Future<void>);

  @override
  void onChange(_i8.Change<_i5.CounterState>? change) => super.noSuchMethod(
    Invocation.method(#onChange, [change]),
    returnValueForMissingStub: null,
  );

  @override
  void addError(Object? error, [StackTrace? stackTrace]) => super.noSuchMethod(
    Invocation.method(#addError, [error, stackTrace]),
    returnValueForMissingStub: null,
  );

  @override
  void onError(Object? error, StackTrace? stackTrace) => super.noSuchMethod(
    Invocation.method(#onError, [error, stackTrace]),
    returnValueForMissingStub: null,
  );
}

/// A class which mocks [GetCounter].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetCounter extends _i1.Mock implements _i2.GetCounter {
  MockGetCounter() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.CounterRepository get counterRepository =>
      (super.noSuchMethod(
            Invocation.getter(#counterRepository),
            returnValue: _FakeCounterRepository_1(
              this,
              Invocation.getter(#counterRepository),
            ),
          )
          as _i3.CounterRepository);

  @override
  _i7.Future<_i4.Either<_i9.Failure, _i10.Counter>> call(
    _i11.NoParams? params,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#call, [params]),
            returnValue:
                _i7.Future<_i4.Either<_i9.Failure, _i10.Counter>>.value(
                  _FakeEither_2<_i9.Failure, _i10.Counter>(
                    this,
                    Invocation.method(#call, [params]),
                  ),
                ),
          )
          as _i7.Future<_i4.Either<_i9.Failure, _i10.Counter>>);
}
