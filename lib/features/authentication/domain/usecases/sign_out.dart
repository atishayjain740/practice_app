import 'package:dartz/dartz.dart';
import 'package:practice_app/core/error/failures.dart';
import 'package:practice_app/core/usecase/usecase.dart';
import 'package:practice_app/features/authentication/domain/entities/user.dart';
import 'package:practice_app/features/authentication/domain/repositories/authentication_repository.dart';

class SignOut implements UseCase<User, NoParams> {
  final AuthenticationRepository authenticationRepository;

  SignOut(this.authenticationRepository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await authenticationRepository.signOut();
  }
}