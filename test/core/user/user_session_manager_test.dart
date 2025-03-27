import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:practice_app/core/user/user_session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:practice_app/core/user/model/user_model.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockPrefs;
  late UserSessionManager sessionManager;
  
  const cachedKey = cachedUserKey;
  
  final testUser = UserModel(
    firstName: 'testf',
    lastName: 'testl',
    email: 'test@test.com'
  );
  
  final testUserJson = jsonEncode(testUser.toJson());

  setUp(() {
    mockPrefs = MockSharedPreferences();
    sessionManager = UserSessionManager(mockPrefs);
  });

  group('UserSessionManager', () {
    test('should return null when no cached user exists', () async {
      // Arrange
      when(() => mockPrefs.getString(cachedKey)).thenReturn(null);
      
      // Act
      await sessionManager.init();
      
      // Assert
      expect(sessionManager.currentUser, isNull);
      expect(sessionManager.isLoggedIn, isFalse);
    });

    test('should return a valid user when cached user exists', () async {
      // Arrange
      when(() => mockPrefs.getString(cachedKey)).thenReturn(testUserJson);
      
      // Act
      await sessionManager.init();
      
      // Assert
      expect(sessionManager.currentUser, equals(testUser));
      expect(sessionManager.isLoggedIn, isTrue);
    });

    test('should return true for isLoggedIn if a user is cached', () async {
      // Arrange
      when(() => mockPrefs.getString(cachedKey)).thenReturn(testUserJson);
      
      // Act
      await sessionManager.init();
      
      // Assert
      expect(sessionManager.isLoggedIn, isTrue);
    });

    test('should return false for isLoggedIn if no user is cached', () async {
      // Arrange
      when(() => mockPrefs.getString(cachedKey)).thenReturn(null);
      
      // Act
      await sessionManager.init();
      
      // Assert
      expect(sessionManager.isLoggedIn, isFalse);
    });

    test('should clear cached user data on logout', () async {
      // Arrange
      when(() => mockPrefs.remove(cachedKey)).thenAnswer((_) async => true);
      
      // Act
      await sessionManager.logout();
      
      // Assert
      verify(() => mockPrefs.remove(cachedKey)).called(1);
      expect(sessionManager.currentUser, isNull);
      expect(sessionManager.isLoggedIn, isFalse);
    });
  });
}
