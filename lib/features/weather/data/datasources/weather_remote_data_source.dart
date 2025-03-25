import 'dart:convert';

import 'package:practice_app/core/error/exceptions.dart';
import 'package:practice_app/features/weather/data/models/weather_model.dart';
import 'package:http/http.dart' as http;

abstract class WeatherRemoteDataSource {
  static const String remoteWeatherApi =
      'https://api.open-meteo.com/v1/forecast?latitude=25.862989&longitude=93.753670&current_weather=true';

  Future<WeatherModel> getWeather();
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final http.Client client;

  WeatherRemoteDataSourceImpl({required this.client});

  @override
  Future<WeatherModel> getWeather() async {
    final response = await client.get(
      Uri.parse(weatherApi),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      try {
        return WeatherModel.fromJson(json.decode(response.body));
      } catch (e) {
        throw ServerException();
      }
    } else {
      throw ServerException();
    }
  }

  String get weatherApi => WeatherRemoteDataSource.remoteWeatherApi;
}
