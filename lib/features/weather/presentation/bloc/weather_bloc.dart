import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_app/core/error/failures.dart';
import 'package:practice_app/core/usecase/usecase.dart';
import 'package:practice_app/features/weather/domain/usecases/get_weather.dart';
import 'package:practice_app/features/weather/presentation/bloc/weather_event.dart';
import 'package:practice_app/features/weather/presentation/bloc/weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetWeather getWeather;
  WeatherBloc({
    required this.getWeather,
  }) : super(WeatherEmpty()) {
    on<GetWeatherEvent>((event, emit) async {
      emit(WeatherLoading());
      final result = await getWeather(NoParams());
      result.fold(
        (failure) => emit(
          WeatherError(
            message:
                failure is ServerFailure
                    ? "Failed to load weather. Server Failure"
                    : "Failed to load weather. Cache Failure",
          ),
        ),
        (weather) => emit(WeatherLoaded(weather: weather)),
      );
    });
  }
}