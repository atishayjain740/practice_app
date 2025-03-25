import 'dart:convert';

import 'package:practice_app/core/error/exceptions.dart';
import 'package:practice_app/features/weather/data/models/weather_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class WeatherLocalDataSource {
  Future<WeatherModel> getWeather();
  Future<void> cacheWeather(WeatherModel weather);
}

const String strCachedWeather = 'CACHED_WEATHER';

class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  final SharedPreferences sharedPreferences;

  WeatherLocalDataSourceImpl({required this.sharedPreferences});
  @override
  Future<void> cacheWeather(WeatherModel weather) async {
    String jsonString = jsonEncode(weather.toJson());
    sharedPreferences.setString(strCachedWeather, jsonString);
  }

  @override
  Future<WeatherModel> getWeather() {
    final jsonString = sharedPreferences.getString(strCachedWeather);
    if (jsonString != null) {
      return Future.value(WeatherModel.fromJson(json.decode(jsonString)));
    } else {
      throw (CacheException());
    }
  }

}