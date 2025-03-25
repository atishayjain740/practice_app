import 'package:practice_app/features/weather/domain/entities/weather.dart';

class WeatherModel extends Weather{
  WeatherModel(
      {super.latitude,
      super.longitude,
      super.generationtimeMs,
      super.utcOffsetSeconds,
      super.timezone,
      super.timezoneAbbreviation,
      super.elevation,
      super.currentWeatherUnits,
      super.currentWeather});

  WeatherModel.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    generationtimeMs = json['generationtime_ms'];
    utcOffsetSeconds = json['utc_offset_seconds'];
    timezone = json['timezone'];
    timezoneAbbreviation = json['timezone_abbreviation'];
    elevation = json['elevation'];
    currentWeatherUnits = CurrentWeatherUnitsModel.fromJson(json['current_weather_units']);
    currentWeather = CurrentWeatherModel.fromJson(json['current_weather']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['generationtime_ms'] = generationtimeMs;
    data['utc_offset_seconds'] = utcOffsetSeconds;
    data['timezone'] = timezone;
    data['timezone_abbreviation'] = timezoneAbbreviation;
    data['elevation'] = elevation;
    if (currentWeatherUnits != null) {
      data['current_weather_units'] = (currentWeatherUnits! as CurrentWeatherUnitsModel?)?.toJson();
    }
    if (currentWeather != null) {
      data['current_weather'] = (currentWeather! as CurrentWeatherModel?)?.toJson();
    }
    return data;
  }
}

class CurrentWeatherUnitsModel extends CurrentWeatherUnits {
  CurrentWeatherUnitsModel(
      {super.time,
      super.interval,
      super.temperature,
      super.windspeed,
      super.winddirection,
      super.isDay,
      super.weathercode});

  CurrentWeatherUnitsModel.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    interval = json['interval'];
    temperature = json['temperature'];
    windspeed = json['windspeed'];
    winddirection = json['winddirection'];
    isDay = json['is_day'];
    weathercode = json['weathercode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    data['interval'] = interval;
    data['temperature'] = temperature;
    data['windspeed'] = windspeed;
    data['winddirection'] = winddirection;
    data['is_day'] = isDay;
    data['weathercode'] = weathercode;
    return data;
  }
}

class CurrentWeatherModel extends CurrentWeather {
  CurrentWeatherModel(
      {super.time,
      super.interval,
      super.temperature,
      super.windspeed,
      super.winddirection,
      super.isDay,
      super.weathercode});

  CurrentWeatherModel.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    interval = json['interval'];
    temperature = json['temperature'];
    windspeed = json['windspeed'];
    winddirection = json['winddirection'];
    isDay = json['is_day'];
    weathercode = json['weathercode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    data['interval'] = interval;
    data['temperature'] = temperature;
    data['windspeed'] = windspeed;
    data['winddirection'] = winddirection;
    data['is_day'] = isDay;
    data['weathercode'] = weathercode;
    return data;
  }
}
