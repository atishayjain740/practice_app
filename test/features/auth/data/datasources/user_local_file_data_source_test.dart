import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:practice_app/core/error/exceptions.dart';
import 'package:practice_app/features/auth/data/datasources/user_local_file_data_source.dart';
import 'package:practice_app/features/auth/data/models/user_model.dart';

class MockFile extends Mock implements File {}

void main() {
  late UserLocalFileDataSourceImpl dataSource;
  late MockFile mockFile;

  final testUser = UserModel(firstName: 'testf', lastName: 'testl', email: 'test@test.com'
  );

  setUp(() {
    mockFile = MockFile();
    dataSource = UserLocalFileDataSourceImpl(file: mockFile);
  });

  group('getUser', () {
    test('should return user when file contains matching email', () async {
      // Arrange
      final users = [testUser];
      when(() => mockFile.existsSync()).thenReturn(true);
      when(() => mockFile.readAsString()).thenAnswer(
        (_) => Future.value(jsonEncode(users.map((e) => e.toJson()).toList()),
      ));

      // Act
      final result = await dataSource.getUser(testUser.email);

      // Assert
      expect(result, equals(testUser));
      verify(() => mockFile.existsSync()).called(1);
      verify(() => mockFile.readAsString()).called(1);
    });

    test('should throw FileException when no matching user found', () async {
      // Arrange
      final users = [testUser];
      when(() => mockFile.existsSync()).thenReturn(true);
      when(() => mockFile.readAsString()).thenAnswer(
        (_) => Future.value(jsonEncode(users.map((e) => e.toJson()).toList()),
      ));

      // Act & Assert
      expect(
        () => dataSource.getUser('nonexistent@example.com'),
        throwsA(isA<FileException>()),
      );
    });

    test('should throw FileException when file does not exist', () async {
      // Arrange
      when(() => mockFile.existsSync()).thenReturn(false);

      // Act & Assert
      expect(
        () => dataSource.getUser(testUser.email),
        throwsA(isA<FileException>()),
      );
    });
  });

  group('saveUser', () {
    test('should save user to file when file exists', () async {
      // Arrange
      final existingUsers = [testUser];
      when(() => mockFile.existsSync()).thenReturn(true);
      when(() => mockFile.readAsString()).thenAnswer(
        (_) => Future.value(jsonEncode(existingUsers.map((e) => e.toJson()).toList()),
      ));
      when(() => mockFile.writeAsString(any())).thenAnswer((_) => Future.value(mockFile));

      final newUser = UserModel(
        email: 'newtest@newtest.com',
        firstName: 'Newtestf',
        lastName: 'Newtestl'
      );

      // Act
      await dataSource.saveUser(newUser);

      // Assert
      verify(() => mockFile.existsSync()).called(1);
      verify(() => mockFile.readAsString()).called(1);
      verify(() => mockFile.writeAsString(
        jsonEncode([...existingUsers, newUser].map((e) => e.toJson()).toList()),
      )).called(1);
    });

    test('should save user to new file when file does not exist', () async {
      // Arrange
      when(() => mockFile.existsSync()).thenReturn(false);
      when(() => mockFile.writeAsString(any())).thenAnswer((_) => Future.value(mockFile));

      // Act
      await dataSource.saveUser(testUser);

      // Assert
      verify(() => mockFile.existsSync()).called(1);
      verify(() => mockFile.writeAsString(
        jsonEncode([testUser].map((e) => e.toJson()).toList()),
      )).called(1);
      verifyNever(() => mockFile.readAsString());
    });
  });

  group('getAllUsers', () {
    test('should return empty list when file does not exist', () async {
      // Arrange
      when(() => mockFile.existsSync()).thenReturn(false);

      // Act
      final result = await dataSource.getAllUsers();

      // Assert
      expect(result, isEmpty);
      verify(() => mockFile.existsSync()).called(1);
      verifyNever(() => mockFile.readAsString());
    });

    test('should return users when file exists', () async {
      // Arrange
      final users = [testUser];
      when(() => mockFile.existsSync()).thenReturn(true);
      when(() => mockFile.readAsString()).thenAnswer(
        (_) => Future.value(jsonEncode(users.map((e) => e.toJson()).toList()),
      ));

      // Act
      final result = await dataSource.getAllUsers();

      // Assert
      expect(result, equals(users));
      verify(() => mockFile.existsSync()).called(1);
      verify(() => mockFile.readAsString()).called(1);
    });

    test('should throw when file exists but contains invalid JSON', () async {
      // Arrange
      when(() => mockFile.existsSync()).thenReturn(true);
      when(() => mockFile.readAsString()).thenAnswer(
        (_) => Future.value('invalid json'),
      );

      // Act & Assert
      expect(() => dataSource.getAllUsers(), throwsA(isA<FormatException>()));
    });
  });
}