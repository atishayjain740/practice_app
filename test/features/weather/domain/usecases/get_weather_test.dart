import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:practice_app/core/usecase/usecase.dart';
import 'package:practice_app/features/weather/domain/entities/weather.dart';
import 'package:practice_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:practice_app/features/weather/domain/usecases/get_weather.dart';

class MockWeatherRepository extends Mock implements WeatherRepository{}

void main() {
  final weather = Weather();
  late MockWeatherRepository mockWeatherRepository;
  late GetWeather useCase;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    useCase = GetWeather(mockWeatherRepository);
  });

  test("should get weather from the repository", () async {
    // arrange
    when(
      () => mockWeatherRepository.getWeather(),
    ).thenAnswer((_) async => Right(weather));
    // act
    final result = await useCase(NoParams());
    // assert
    expect(result, Right(weather));
    verify(() => mockWeatherRepository.getWeather());
    verifyNoMoreInteractions(mockWeatherRepository);
  });
}
