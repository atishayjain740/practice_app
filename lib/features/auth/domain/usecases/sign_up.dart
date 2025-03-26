import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:practice_app/core/error/failures.dart';
import 'package:practice_app/core/usecase/usecase.dart';
import 'package:practice_app/features/auth/domain/entities/user.dart';
import 'package:practice_app/features/auth/domain/repositories/auth_repository.dart';

class SignUp implements UseCase<User, Params> {
  final AuthRepository authRepository;

  SignUp(this.authRepository);

  @override
  Future<Either<Failure, User>> call(Params params) async {
    return await authRepository.signUp(params.user);
  }
}

class Params extends Equatable {
  final User user;
  const Params({required this.user});

  @override
  List<Object?> get props => [user];
}