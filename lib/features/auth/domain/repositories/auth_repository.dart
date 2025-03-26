import 'package:dartz/dartz.dart';
import 'package:practice_app/core/error/failures.dart';
import 'package:practice_app/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signIn(String email);
  Future<Either<Failure, User>> signUp(User user);
  Future<Either<Failure, bool>> signOut();
}