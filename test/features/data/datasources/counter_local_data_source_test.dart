import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:practice_app/features/counter/data/datasources/counter_local_data_source.dart';
import 'package:practice_app/features/counter/data/models/counter_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../fixtures/fixture_reader.dart';
import 'package:practice_app/core/error/exceptions.dart';

class MockSharedPreferences extends Mock implements SharedPreferences{}

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late CounterLocalDataSourceImpl counterLocalDataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    counterLocalDataSource = CounterLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('get last counter', () {
    final tCounter = CounterModel.fromJson(
      json.decode(fixture('counter_cache.json')),
    );
    test('should get cached data if there is one', () async {
      // arrange
      when(
        () => mockSharedPreferences.getString(any()),
      ).thenReturn(fixture('counter_cache.json'));
      // act
      final result = await counterLocalDataSource.getCounter();
      // assert
      verify(() => mockSharedPreferences.getString(cachedCounter));
      expect(result, equals(tCounter));
    });

    test('should throw cache exception if there is no cache', () async {
      // arrange
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);
      // act
      final call = counterLocalDataSource.getCounter;
      // assert
      expect(() => call(), throwsA(isInstanceOf<CacheException>()));
    });
  });

  group('cache last counter', () {
    CounterModel counterModel = CounterModel(count: 0);
    String jsonString = jsonEncode(counterModel.toJson());
    test('should cache the value', () async {
      // arrange
      when(
        () => mockSharedPreferences.setString(cachedCounter, jsonString),
      ).thenAnswer((_) async => true);
      // act
      await counterLocalDataSource.cacheCounter(counterModel);
      // assert
      verify(() => mockSharedPreferences.setString(cachedCounter, jsonString));
    });
  });
}
