import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:practice_app/core/constants/dummy_url.dart';
import 'package:practice_app/core/error/exceptions.dart';
import 'package:practice_app/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:practice_app/features/weather/data/models/weather_model.dart';

import '../../fixtures/fixture_reader.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late MockClient mockClient;
  late WeatherRemoteDataSourceImpl dataSource;

  setUpAll((){
    registerFallbackValue(Uri.parse(dummyUrl));
  });

  setUp(() {
    mockClient = MockClient();
    dataSource = WeatherRemoteDataSourceImpl(client: mockClient);
  });

  void setUpSuccessHttpGetRequest() {
    when(
      () => mockClient.get(any(), headers: any(named: 'headers')),
    ).thenAnswer((_) async => http.Response(fixture('weather.json'), 200));
  }

  void setUpFailureHttpGetRequest() {
    when(
      () => mockClient.get(any(), headers: any(named: 'headers')),
    ).thenAnswer((_) async => http.Response('something went wrong', 404));
  }

  void setUpWrongDataRequest() {
    when(
      () => mockClient.get(any(), headers: any(named: 'headers')),
    ).thenAnswer((_) async => http.Response(fixture('weather_invalid.json'), 200));
  }

  group('get weather', () {
    final WeatherModel weatherModel = WeatherModel.fromJson(
      json.decode(fixture('weather.json')),
    );
    test(
      'should perform a get request with url for getting the weather and with application/json as header',
      () {
        // arrange
        setUpSuccessHttpGetRequest();

        // act
        dataSource.getWeather();
        // assert
        verify(
          () => mockClient.get(
            Uri.parse(
              dataSource.weatherApi,
            ),
            headers: {'Content-Type': 'application/json'},
          ),
        );
      },
    );

    test('should return weather when the response code is success', () async {
      // arrange
      setUpSuccessHttpGetRequest();
      // act
      final result = await dataSource.getWeather();
      // assert
      expect(result, equals(weatherModel));
    });

    test(
      'should throw server exception when the response code is not success',
      () async {
        // arrange
        setUpFailureHttpGetRequest();

        // act
        final call = dataSource.getWeather;
        // assert
        expect(() => call(), throwsA(isInstanceOf<ServerException>()));
      },
    );

    test(
      'should throw exception when the response code is success but wrong data sent',
      () async {
        // arrange
        setUpWrongDataRequest();

        // act
        final call = dataSource.getWeather;
        // assert
        expect(() => call(), throwsA(isInstanceOf<ServerException>()));
      },
    );
});
}
