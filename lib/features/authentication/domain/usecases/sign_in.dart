import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:practice_app/core/error/failures.dart';
import 'package:practice_app/core/usecase/usecase.dart';
import 'package:practice_app/features/authentication/domain/entities/user.dart';
import 'package:practice_app/features/authentication/domain/repositories/authentication_repository.dart';

class SignIn implements UseCase<User, Params> {
  final AuthenticationRepository authenticationRepository;

  SignIn(this.authenticationRepository);

  @override
  Future<Either<Failure, User>> call(Params params) async {
    return await authenticationRepository.signIn(params.email);
  }
}

class Params extends Equatable {
  final String email;
  const Params({required this.email});

  @override
  List<Object?> get props => [email];
}