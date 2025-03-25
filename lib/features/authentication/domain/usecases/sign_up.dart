import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:practice_app/core/error/failures.dart';
import 'package:practice_app/core/usecase/usecase.dart';
import 'package:practice_app/features/authentication/domain/entities/user.dart';
import 'package:practice_app/features/authentication/domain/repositories/authentication_repository.dart';

class SignUp implements UseCase<User, Params> {
  final AuthenticationRepository authenticationRepository;

  SignUp(this.authenticationRepository);

  @override
  Future<Either<Failure, User>> call(Params params) async {
    return await authenticationRepository.signUp(params.user);
  }
}

class Params extends Equatable {
  final User user;
  const Params({required this.user});

  @override
  List<Object?> get props => [user];
}