import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:practice_app/core/error/exceptions.dart';
import 'package:practice_app/core/error/failures.dart';
import 'package:practice_app/core/user/user_session_manager.dart';
import 'package:practice_app/features/auth/data/datasources/user_local_cache_data_source.dart';
import 'package:practice_app/features/auth/data/datasources/user_local_db_data_source.dart';
import 'package:practice_app/core/user/model/user_model.dart';
import 'package:practice_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:practice_app/core/user/entity/user.dart';

class MockUserLocalCacheDataSource extends Mock implements UserLocalCacheDataSource {}
class MockUserLocalDBDataSource extends Mock implements UserLocalDBDataSource {}
class MockUserSessionManager extends Mock implements UserSessionManager{}

void main() {
  late AuthRepositoryImpl repository;
  late MockUserLocalCacheDataSource mockCacheDataSource;
  late MockUserLocalDBDataSource mockDBDataSource;
  late MockUserSessionManager mockUserSessionManager;

  UserModel testUserModel = UserModel(firstName: 'testf', lastName: 'testl', email: 'test@test.com'
  );

  User testUser = testUserModel;

  setUp(() {
    mockCacheDataSource = MockUserLocalCacheDataSource();
    mockDBDataSource = MockUserLocalDBDataSource();
    mockUserSessionManager = MockUserSessionManager();
    repository = AuthRepositoryImpl(
      cacheDataSource: mockCacheDataSource,
      dbDataSource: mockDBDataSource,
      userSessionManager: mockUserSessionManager
    );
  });

  group('signIn', () {
    test('should return cached user when sign in is successful', () async {
      // Arrange
      when(() => mockDBDataSource.getUser(testUserModel.email))
          .thenAnswer((_) async => testUserModel);
      when(() => mockCacheDataSource.cacheUser(testUserModel))
          .thenAnswer((_) async => true);
      when(() => mockUserSessionManager.init())
          .thenAnswer((_) async => true);

      // Act
      final result = await repository.signIn(testUserModel.email);

      // Assert
      expect(result, Right(testUser));
      verify(() => mockDBDataSource.getUser(testUserModel.email)).called(1);
      verify(() => mockCacheDataSource.cacheUser(testUserModel)).called(1);
      verify(() => mockUserSessionManager.init()).called(1);
    });

    test('should return CacheFailure when file data source throws', () async {
      // Arrange
      when(() => mockDBDataSource.getUser(testUserModel.email))
          .thenThrow(Exception());
      when(() => mockCacheDataSource.cacheUser(testUserModel))
          .thenAnswer((_) async => true);

      // Act
      final result = await repository.signIn(testUserModel.email);

      // Assert
      expect(result, Left(CacheFailure()));
      verify(() => mockDBDataSource.getUser(testUserModel.email));
      verifyNever(() => mockCacheDataSource.cacheUser(testUserModel));
    });

    test('should return CacheFailure when cache fails', () async {
      // Arrange
      when(() => mockDBDataSource.getUser(testUserModel.email))
          .thenAnswer((_) async => testUserModel);
      when(() => mockCacheDataSource.cacheUser(testUserModel))
          .thenThrow(Exception());

      // Act
      final result = await repository.signIn(testUserModel.email);

      // Assert
      expect(result, Left(CacheFailure()));
      verify(() => mockDBDataSource.getUser(testUserModel.email));
      verify(() => mockCacheDataSource.cacheUser(testUserModel));
    });
  });

  group('signOut', () {
    test('should return true when sign out is successful', () async {
      // Arrange
      when(() => mockCacheDataSource.clearCache())
          .thenAnswer((_) async => true);
      when(() => mockUserSessionManager.init())
          .thenAnswer((_) async => true);

      // Act
      final result = await repository.signOut();

      // Assert
      expect(result, Right(true));
      verify(() => mockCacheDataSource.clearCache());
      verify(() => mockUserSessionManager.init()).called(1);
    });

    test('should return CacheFailure when sign out fails', () async {
      // Arrange
      when(() => mockCacheDataSource.clearCache())
          .thenThrow(Exception());

      // Act
      final result = await repository.signOut();

      // Assert
      expect(result, Left(CacheFailure()));
      verify(() => mockCacheDataSource.clearCache());
    });
  });

  group('signUp', () {
    test('should return user when sign up is successful', () async {
      // Arrange
      when(() => mockDBDataSource.saveUser(testUserModel))
          .thenAnswer((_) async => testUserModel);
      when(() => mockUserSessionManager.init())
          .thenAnswer((_) async => true);
      when(() => mockCacheDataSource.cacheUser(testUserModel))
          .thenAnswer((_) async => true);

      // Act
      final result = await repository.signUp(testUser);

      // Assert
      expect(result, Right(testUser));
      verify(() => mockDBDataSource.saveUser(testUserModel));
      verify(() => mockCacheDataSource.cacheUser(testUserModel));
      verify(() => mockUserSessionManager.init()).called(1);
    });

    test('should return DBFailure when DB exception occurs', () async {
      // Arrange
      when(() => mockDBDataSource.saveUser(testUserModel))
          .thenThrow(DBException());

      // Act
      final result = await repository.signUp(testUser);

      // Assert
      expect(result, Left(DBFailure()));
      verify(() => mockDBDataSource.saveUser(testUserModel));
    });

    test('should return FileFailure when file exception occurs', () async {
      // Arrange
      when(() => mockDBDataSource.saveUser(testUserModel))
          .thenThrow(FileException());

      // Act
      final result = await repository.signUp(testUser);

      // Assert
      expect(result, Left(FileFailure()));
      verify(() => mockDBDataSource.saveUser(testUserModel));
    });
  });
}