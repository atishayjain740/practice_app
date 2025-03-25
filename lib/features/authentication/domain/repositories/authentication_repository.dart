import 'package:dartz/dartz.dart';
import 'package:practice_app/core/error/failures.dart';
import 'package:practice_app/features/authentication/domain/entities/user.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, User>> signIn(String email);
  Future<Either<Failure, User>> signUp(User user);
  Future<Either<Failure, User>> signOut();
}