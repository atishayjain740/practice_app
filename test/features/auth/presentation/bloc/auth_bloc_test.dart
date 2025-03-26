import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:practice_app/core/error/failures.dart';
import 'package:practice_app/core/usecase/usecase.dart';
import 'package:practice_app/features/auth/domain/entities/user.dart';
import 'package:practice_app/features/auth/domain/usecases/sign_in.dart' as si;
import 'package:practice_app/features/auth/domain/usecases/sign_out.dart';
import 'package:practice_app/features/auth/domain/usecases/sign_up.dart' as su;
import 'package:practice_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:practice_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:practice_app/features/auth/presentation/bloc/auth_state.dart';

class MockSignIn extends Mock implements si.SignIn {}

class MockSignOut extends Mock implements SignOut {}

class MockSignUp extends Mock implements su.SignUp {}

void main() {
  late AuthBloc authBloc;
  late MockSignIn mockSignIn;
  late MockSignOut mockSignOut;
  late MockSignUp mockSignUp;

  User testUser = User(
    firstName: 'John',
    lastName: 'Doe',
    email: 'john.doe@example.com',
  );

  setUp(() {
    mockSignIn = MockSignIn();
    mockSignOut = MockSignOut();
    mockSignUp = MockSignUp();
    authBloc = AuthBloc(
      signIn: mockSignIn,
      signOut: mockSignOut,
      signUp: mockSignUp,
    );
  });

  group('AuthBloc', () {
    test('initial state should be AuthInitial', () {
      expect(authBloc.state, equals(AuthInitail()));
    });

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthLoaded] when SignInEvent is added and successful',
      build: () {
        when(() => mockSignIn(si.Params(email: testUser.email))).thenAnswer((_) async => Right(testUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(const SignInEvent(email: 'john.doe@example.com')),
      expect: () => [AuthLoading(), AuthLoaded(user: testUser)],
      verify: (_) {
        verify(
          () => mockSignIn(const si.Params(email: 'john.doe@example.com')),
        ).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] with CacheFailure message when SignInEvent fails with CacheFailure',
      build: () {
        when(
          () => mockSignIn(si.Params(email: testUser.email)),
        ).thenAnswer((_) async => Left(CacheFailure()));
        return authBloc;
      },
      act: (bloc) => bloc.add(const SignInEvent(email: 'john.doe@example.com')),
      expect:
          () => [
            AuthLoading(),
            AuthError(message: "There was problem logging in."),
          ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] with other failure message when SignInEvent fails with other failure',
      build: () {
        when(
          () => mockSignIn(si.Params(email: testUser.email)),
        ).thenAnswer((_) async => Left(FileFailure()));
        return authBloc;
      },
      act: (bloc) => bloc.add(const SignInEvent(email: 'john.doe@example.com')),
      expect: () => [AuthLoading(), AuthError(message: "User not registered")],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthLoaded] when SignUpEvent is added and successful',
      build: () {
        when(() => mockSignUp(su.Params(user: testUser))).thenAnswer((_) async => Right(testUser));
        return authBloc;
      },
      act:
          (bloc) => bloc.add(
            const SignUpEvent(
              firstName: 'John',
              lastName: 'Doe',
              email: 'john.doe@example.com',
            ),
          ),
      expect: () => [AuthLoading(), AuthLoaded(user: testUser)],
      verify: (_) {
        verify(() => mockSignUp(su.Params(user: testUser))).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] with CacheFailure message when SignUpEvent fails with CacheFailure',
      build: () {
        when(
          () => mockSignUp(su.Params(user: testUser)),
        ).thenAnswer((_) async => Left(CacheFailure()));
        return authBloc;
      },
      act:
          (bloc) => bloc.add(
            const SignUpEvent(
              firstName: 'John',
              lastName: 'Doe',
              email: 'john.doe@example.com',
            ),
          ),
      expect:
          () => [
            AuthLoading(),
            AuthError(message: "There was problem logging in."),
          ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] with other failure message when SignUpEvent fails with other failure',
      build: () {
        when(
          () => mockSignUp(su.Params(user: testUser)),
        ).thenAnswer((_) async => Left(FileFailure()));
        return authBloc;
      },
      act:
          (bloc) => bloc.add(
            const SignUpEvent(
              firstName: 'John',
              lastName: 'Doe',
              email: 'john.doe@example.com',
            ),
          ),
      expect: () => [AuthLoading(), AuthError(message: "User not registered")],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthInitial] when SignOutEvent is added and successful',
      build: () {
        when(
          () => mockSignOut(NoParams()),
        ).thenAnswer((_) async => const Right(true));
        return authBloc;
      },
      act: (bloc) => bloc.add(SignOutEvent()),
      expect: () => [AuthLoading(), AuthInitail()],
      verify: (_) {
        verify(() => mockSignOut(NoParams())).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when SignOutEvent fails',
      build: () {
        when(
          () => mockSignOut(NoParams()),
        ).thenAnswer((_) async => Left(CacheFailure()));
        return authBloc;
      },
      act: (bloc) => bloc.add(SignOutEvent()),
      expect:
          () => [
            AuthLoading(),
            AuthError(message: "There was some problem signing out the user"),
          ],
    );
  });
}
