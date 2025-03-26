import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:practice_app/core/error/exceptions.dart';
import 'package:practice_app/features/auth/data/datasources/user_local_cache_data_source.dart';
import 'package:practice_app/core/user/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late UserLocalCacheDataSourceImpl userLocalCacheDataSource;
  late String strValidUserFixtureFileName = 'user.json';
  final UserModel userModel = UserModel.fromJson(
      json.decode(fixture(strValidUserFixtureFileName)),
    );

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    userLocalCacheDataSource = UserLocalCacheDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('get user', () {
    
    test('should get cached data if there is one', () async {
      // arrange
      when(
        () => mockSharedPreferences.getString(any()),
      ).thenReturn(fixture(strValidUserFixtureFileName));
      // act
      final result = await userLocalCacheDataSource.getUser();
      // assert
      verify(() => mockSharedPreferences.getString(any()));
      expect(result, equals(userModel));
    });

    test('should throw cache exception if there is no cache', () async {
      // arrange
      when(() => mockSharedPreferences.getString(strCachedUser)).thenReturn(null);
      // act
      final call = userLocalCacheDataSource.getUser;
      // assert
      expect(() => call(), throwsA(isInstanceOf<CacheException>()));
    });
  });

  group('cache user', () {
    
    String jsonString = jsonEncode(userModel.toJson());
    test('should cache the value', () async {
      // arrange
      when(
        () => mockSharedPreferences.setString(strCachedUser, jsonString),
      ).thenAnswer((_) async => true);
      // act
      await userLocalCacheDataSource.cacheUser(userModel);
      // assert
      verify(() => mockSharedPreferences.setString(strCachedUser, jsonString));
    });
  });

  group('remove cached user', () {
    
    test('should remove the cache', () async {
      // arrange
      when(
        () => mockSharedPreferences.remove(strCachedUser),
      ).thenAnswer((_) async => true);
      // act
      await userLocalCacheDataSource.clearCache();
      // assert
      verify(() => mockSharedPreferences.remove(strCachedUser)).called(1);
    });

    test('should throw cache exception if false return from remove cache', () async {
      // arrange
      when(
        () => mockSharedPreferences.remove(strCachedUser),
      ).thenAnswer((_) async => false);
      // act
      final call = userLocalCacheDataSource.clearCache;
      // assert
      expect(() => call(), throwsA(isInstanceOf<CacheException>()));
    });
  });
}
