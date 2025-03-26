import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_app/core/error/failures.dart';
import 'package:practice_app/core/usecase/usecase.dart';
import 'package:practice_app/features/auth/domain/entities/user.dart';
import 'package:practice_app/features/auth/domain/usecases/sign_in.dart' as si;
import 'package:practice_app/features/auth/domain/usecases/sign_out.dart';
import 'package:practice_app/features/auth/domain/usecases/sign_up.dart' as su;
import 'package:practice_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:practice_app/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final si.SignIn signIn;
  final SignOut signOut;
  final su.SignUp signUp;

  AuthBloc({required this.signIn, required this.signOut, required this.signUp})
    : super(AuthInitail()) {
    on<SignInEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await signIn(si.Params(email: event.email));
      result.fold(
        (failure) => emit(
          AuthError(
            message:
                failure is CacheFailure
                    ? "There was problem logging in."
                    : "User not registered",
          ),
        ),
        (user) => emit(AuthLoaded(user: user)),
      );
    });

    on<SignUpEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await signUp(
        su.Params(
          user: User(
            firstName: event.firstName,
            lastName: event.lastName,
            email: event.email,
          ),
        ),
      );
      result.fold(
        (failure) => emit(
          AuthError(
            message:
                failure is CacheFailure
                    ? "There was problem logging in."
                    : "User not registered",
          ),
        ),
        (user) => emit(AuthLoaded(user: user)),
      );
    });

    on<SignOutEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await signOut(NoParams());
      result.fold(
        (failure) => emit(
          AuthError(
            message: "There was some problem signing out the user"
          ),
        ),
        (result) => emit(AuthInitail()),
      );
    });
  }
}
