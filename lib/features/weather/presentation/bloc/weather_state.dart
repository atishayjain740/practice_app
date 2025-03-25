import 'package:equatable/equatable.dart';
import 'package:practice_app/features/weather/domain/entities/weather.dart';

class WeatherState extends Equatable{

  @override
  List<Object?> get props => [];
  
}

class WeatherEmpty extends WeatherState {}


class WeatherLoading extends WeatherState {}


class WeatherLoaded extends WeatherState {
  final Weather weather;
  WeatherLoaded({required this.weather});
}

class WeatherError extends WeatherState {
  final String message;

  WeatherError({required this.message});
}