import 'package:dartz/dartz.dart';
import 'package:practice_app/core/error/exceptions.dart';
import 'package:practice_app/core/error/failures.dart';
import 'package:practice_app/features/auth/data/datasources/user_local_cache_data_source.dart';
import 'package:practice_app/features/auth/data/datasources/user_local_file_data_source.dart';
import 'package:practice_app/features/auth/data/models/user_model.dart';
import 'package:practice_app/features/auth/domain/entities/user.dart';
import 'package:practice_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final UserLocalCacheDataSource cacheDataSource;
  final UserLocalFileDataSource fileDataSource;

  const AuthRepositoryImpl({
    required this.cacheDataSource,
    required this.fileDataSource,
  });

  @override
  Future<Either<Failure, User>> signIn(String email) async {
    try {
      final user = await fileDataSource.getUser(email);
      await cacheDataSource.cacheUser(user);
      return Right(user);
    } catch (e) {
      return left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> signOut() async {
    try {
      await cacheDataSource.clearCache();
      return Right(true);
    } catch (e) {
      return left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, User>> signUp(User user) async {
    try {
      // Save the user info in file
      final result = await fileDataSource.saveUser(user as UserModel);
      return Right(result);
    } on FileException {
      return Left(FileFailure());
    }
  }
}
