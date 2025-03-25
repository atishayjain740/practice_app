import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:practice_app/core/error/exceptions.dart';
import 'package:practice_app/core/error/failures.dart';
import 'package:practice_app/core/network/netrwork_info.dart';
import 'package:practice_app/features/weather/data/datasources/weather_local_data_source.dart';
import 'package:practice_app/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:practice_app/features/weather/data/models/weather_model.dart';
import 'package:practice_app/features/weather/data/repositories/weather_repository_impl.dart';
import '../../fixtures/fixture_reader.dart';

class MockWeatherRemoteDataSource extends Mock
    implements WeatherRemoteDataSource {}

class MockWeatherLocalDataSource extends Mock
    implements WeatherLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockWeatherRemoteDataSource mockWeatherRemoteDataSource;
  late MockWeatherLocalDataSource mockWeatherLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late WeatherRepositoryImpl weatherRepository;
  final String strValidWeatherFixtureFileName = 'weather.json';
  final WeatherModel weatherModel = WeatherModel.fromJson(
    json.decode(fixture(strValidWeatherFixtureFileName)),
  );

  setUp(() {
    mockWeatherRemoteDataSource = MockWeatherRemoteDataSource();
    mockWeatherLocalDataSource = MockWeatherLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    weatherRepository = WeatherRepositoryImpl(
      localDataSource: mockWeatherLocalDataSource,
      remoteDataSource: mockWeatherRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  test("should check if the device is online", () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockWeatherRemoteDataSource.getWeather(),
      ).thenAnswer((_) async => weatherModel);
      when(
        () => mockWeatherLocalDataSource.cacheWeather(weatherModel),
      ).thenAnswer((_) async => true);
      // act
      await weatherRepository.getWeather();
      // assert
      verify(() => mockNetworkInfo.isConnected);
    });

  group('device online', () {
    setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

    void setUpSuccessRemoteDataCall() {
        when(
          () => mockWeatherRemoteDataSource.getWeather(),
          ).thenAnswer((_) async => weatherModel);

          when(
          () => mockWeatherLocalDataSource.cacheWeather(weatherModel),
          ).thenAnswer((_) async => true);
      }

      void setUpFailureRemoteDataCall() {
        when(
            () => mockWeatherRemoteDataSource.getWeather(),
          ).thenThrow(ServerException());
      }

      test(
        "should return remote data when call to remote data is success",
        () async {
          // arrange
          setUpSuccessRemoteDataCall();
          // act
          final result = await weatherRepository.getWeather();
          // assert
          verify(() => mockWeatherRemoteDataSource.getWeather());
          expect(result, equals(Right(weatherModel)));
        },
      );

      test(
        "should cache remote data locally when call to remote data is success",
        () async {
          // arrange
          setUpSuccessRemoteDataCall();

          // act
          await weatherRepository.getWeather();
          // assert
          verify(() => mockWeatherLocalDataSource.cacheWeather(weatherModel));
        },
      );

      test(
        "should return server exception when call to remote data is unsuccessful",
        () async {
          // arrange
          setUpFailureRemoteDataCall();
          // act
          final result = await weatherRepository.getWeather();
          // assert
          verify(() => mockWeatherRemoteDataSource.getWeather());
          verifyZeroInteractions(mockWeatherLocalDataSource);
          expect(result, Left(ServerFailure()));
        },
      );
  });

  group('device offline', () {
    setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        "should return the last locally cached data when the cached data is present",
        () async {
          // arrange
          when(
            () => mockWeatherLocalDataSource.getWeather(),
          ).thenAnswer((_) async => weatherModel);
          // act
          final result = await weatherRepository.getWeather();
          // assert
          verifyZeroInteractions(mockWeatherRemoteDataSource);
          verify(() => mockWeatherLocalDataSource.getWeather());
          expect(result, equals(Right(weatherModel)));
        },
      );

      test(
        "should return CacheFailure when the cached data is not present",
        () async {
          // arrange
          when(
            () => mockWeatherLocalDataSource.getWeather(),
          ).thenThrow(CacheException());
          // act
          final result = await weatherRepository.getWeather();
          // assert
          verifyZeroInteractions(mockWeatherRemoteDataSource);
          verify(() => mockWeatherLocalDataSource.getWeather());
          expect(result, equals(Left(CacheFailure())));
        },
      );
  });
}
