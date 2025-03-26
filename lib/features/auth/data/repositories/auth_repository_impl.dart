import 'package:dartz/dartz.dart';
import 'package:practice_app/core/error/exceptions.dart';
import 'package:practice_app/core/error/failures.dart';
import 'package:practice_app/core/user/user_session_manager.dart';
import 'package:practice_app/features/auth/data/datasources/user_local_cache_data_source.dart';
import 'package:practice_app/features/auth/data/datasources/user_local_file_data_source.dart';
import 'package:practice_app/core/user/model/user_model.dart';
import 'package:practice_app/core/user/entity/user.dart';
import 'package:practice_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final UserLocalCacheDataSource cacheDataSource;
  final UserLocalFileDataSource fileDataSource;
  final UserSessionManager userSessionManager;

  const AuthRepositoryImpl({
    required this.cacheDataSource,
    required this.fileDataSource,
    required this.userSessionManager
  });

  @override
  Future<Either<Failure, User>> signIn(String email) async {
    try {
      // Find the user in files
      final user = await fileDataSource.getUser(email);
      // Cache the user and sign in
      await cacheDataSource.cacheUser(user);
      await userSessionManager.init();
      return Right(user);
    } catch (e) {
      return left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> signOut() async {
    try {
      await cacheDataSource.clearCache();
      await userSessionManager.init();
      return Right(true);
    } catch (e) {
      return left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, User>> signUp(User user) async {
    try {
      // Save the user info in file
      final result = await fileDataSource.saveUser(UserModel(firstName: user.firstName, lastName: user.lastName, email: user.email));
      // Cache the user and sign in
      await cacheDataSource.cacheUser(result);
      await userSessionManager.init();
      return Right(result);
    } on FileException {
      return Left(FileFailure());
    }
  }
}
