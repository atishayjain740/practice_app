import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:practice_app/core/error/failures.dart';
import 'package:practice_app/core/usecase/usecase.dart';
import 'package:practice_app/core/user/entity/user.dart';
import 'package:practice_app/features/auth/domain/repositories/auth_repository.dart';

class SignIn implements UseCase<User, Params> {
  final AuthRepository authRepository;

  SignIn(this.authRepository);

  @override
  Future<Either<Failure, User>> call(Params params) async {
    return await authRepository.signIn(params.email);
  }
}

class Params extends Equatable {
  final String email;
  const Params({required this.email});

  @override
  List<Object?> get props => [email];
}