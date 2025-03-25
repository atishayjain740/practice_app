import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:practice_app/core/error/exceptions.dart';
import 'package:practice_app/features/weather/data/datasources/weather_local_data_source.dart';
import 'package:practice_app/features/weather/data/models/weather_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late WeatherLocalDataSourceImpl weatherLocalDataSource;
  late String strValidWeatherFixtureFileName = 'weather.json';
  final WeatherModel weatherModel = WeatherModel.fromJson(
      json.decode(fixture(strValidWeatherFixtureFileName)),
    );

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    weatherLocalDataSource = WeatherLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('get weather', () {
    
    test('should get cached data if there is one', () async {
      // arrange
      when(
        () => mockSharedPreferences.getString(any()),
      ).thenReturn(fixture(strValidWeatherFixtureFileName));
      // act
      final result = await weatherLocalDataSource.getWeather();
      // assert
      verify(() => mockSharedPreferences.getString(any()));
      expect(result, equals(weatherModel));
    });

    test('should throw cache exception if there is no cache', () async {
      // arrange
      when(() => mockSharedPreferences.getString(strCachedWeather)).thenReturn(null);
      // act
      final call = weatherLocalDataSource.getWeather;
      // assert
      expect(() => call(), throwsA(isInstanceOf<CacheException>()));
    });
  });

  group('cache weather', () {
    
    String jsonString = jsonEncode(weatherModel.toJson());
    test('should cache the value', () async {
      // arrange
      when(
        () => mockSharedPreferences.setString(strCachedWeather, jsonString),
      ).thenAnswer((_) async => true);
      // act
      await weatherLocalDataSource.cacheWeather(weatherModel);
      // assert
      verify(() => mockSharedPreferences.setString(strCachedWeather, jsonString));
    });
  });
}
