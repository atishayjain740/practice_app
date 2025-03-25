import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:practice_app/features/weather/data/models/weather_model.dart';
import 'package:practice_app/features/weather/domain/entities/weather.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  WeatherModel weatherModel = WeatherModel(
    latitude: 25.875,
    longitude: 93.75,
    generationtimeMs: 0.0475645065307617,
    utcOffsetSeconds: 0,
    timezone: "GMT",
    timezoneAbbreviation: "GMT",
    elevation: 164,
    currentWeatherUnits: CurrentWeatherUnitsModel(
      time: "iso8601",
      interval: "seconds",
      temperature: "°C",
      windspeed: "km/h",
      winddirection: "°",
      isDay: "",
      weathercode: "wmo code",
    ),
    currentWeather: CurrentWeatherModel(
      time: "2025-03-25T05:15",
      interval: 900,
      temperature: 29.7,
      windspeed: 4.7,
      winddirection: 328,
      isDay: 1,
      weathercode: 0,
    ),
  );

  test("should be a weather entity", () {
    expect(weatherModel, isA<Weather>());
  });

  group('from json', () {
    test("should return a valid model when the json is correct", () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture('weather.json'));
      final result = WeatherModel.fromJson(jsonMap);

      expect(result, isInstanceOf<WeatherModel>());
    });

    test("should return exception when the json is incorrect", () async {
      final Map<String, dynamic> jsonMap = json.decode(
        fixture('weather_invalid.json'),
      );
      expect(() => WeatherModel.fromJson(jsonMap), throwsA(isA<TypeError>()));
    });
  });

  group('to json', () {
    test("should return a json map containing the proper data", () async {
      final result = weatherModel.toJson();
      final Map<String, dynamic> expectedMap = json.decode(fixture('weather.json'));
      expect(result, expectedMap);
    });
  });
}
