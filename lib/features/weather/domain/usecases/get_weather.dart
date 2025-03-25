import 'package:dartz/dartz.dart';
import 'package:practice_app/core/error/failures.dart';
import 'package:practice_app/core/usecase/usecase.dart';
import 'package:practice_app/features/weather/domain/entities/weather.dart';
import 'package:practice_app/features/weather/domain/repositories/weather_repository.dart';

class GetWeather implements UseCase<Weather, NoParams> {
  final WeatherRepository weatherRepository;

  GetWeather(this.weatherRepository);

  @override
  Future<Either<Failure, Weather>> call(NoParams params) async {
    return await weatherRepository.getWeather();
  }
}