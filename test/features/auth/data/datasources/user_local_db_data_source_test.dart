import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:practice_app/features/auth/data/datasources/user_local_db_data_source.dart';
import 'package:sqflite/sqflite.dart';
import 'package:practice_app/core/user/model/user_model.dart';
import 'package:practice_app/core/error/exceptions.dart';

class MockDatabase extends Mock implements Database {}

void main() {
  late UserLocalDatabaseDataSourceImpl dataSource;
  late MockDatabase mockDatabase;

  setUp(() {
    mockDatabase = MockDatabase();
    dataSource = UserLocalDatabaseDataSourceImpl(database: mockDatabase);
  });

  final testUser = UserModel(
    firstName: 'testf',
    lastName: 'testl',
    email: 'test@test.com',
  );

  group('UserLocalDatabaseDataSource Tests', () {
    test('should save user to database', () async {
      when(
        () => mockDatabase.insert(
          userTable, // Fixed: Using table name instead of database name
          {
            'firstname': testUser.firstName,
            'lastname': testUser.lastName,
            'email': testUser.email,
          },
          conflictAlgorithm: ConflictAlgorithm.fail,
        ),
      ).thenAnswer((_) async => Future.value(1));

      final result = await dataSource.saveUser(testUser);
      expect(result.email, testUser.email);
    });

    test('should throw exception when trying to save duplicate user', () async {
      when(() => mockDatabase.insert(any(), any())).thenThrow(DBException());

      expect(() => dataSource.saveUser(testUser), throwsA(isA<DBException>()));
    });

    test('should retrieve user from database', () async {
      when(
        () => mockDatabase.query(
          any(),
          where: any(named: 'where'),
          whereArgs: any(named: 'whereArgs'),
        ),
      ).thenAnswer(
        (_) async => [
          {
            'firstname': testUser.firstName,
            'lastname': testUser.lastName,
            'email': testUser.email,
          },
        ],
      );

      final result = await dataSource.getUser(testUser.email);
      expect(result.email, testUser.email);
    });

    test('should throw exception when retrieving non-existent user', () async {
      when(
        () => mockDatabase.query(
          any(),
          where: any(named: 'where'),
          whereArgs: any(named: 'whereArgs'),
        ),
      ).thenAnswer((_) async => []);

      expect(
        () => dataSource.getUser('nonexistent@example.com'),
        throwsA(isA<DBException>()),
      );
    });
  });
}
