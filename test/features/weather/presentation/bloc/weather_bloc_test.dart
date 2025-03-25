import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:practice_app/core/error/failures.dart';
import 'package:practice_app/core/usecase/usecase.dart';
import 'package:practice_app/features/weather/domain/entities/weather.dart';
import 'package:practice_app/features/weather/domain/usecases/get_weather.dart';
import 'package:practice_app/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:practice_app/features/weather/presentation/bloc/weather_event.dart';
import 'package:practice_app/features/weather/presentation/bloc/weather_state.dart';

class MockGetWeather extends Mock implements GetWeather{}

void main() {
  late MockGetWeather mockGetWeather;
  late WeatherBloc weatherBloc;
  Weather weather = Weather(
    latitude: 25.875,
    longitude: 93.75,
    generationtimeMs: 0.0475645065307617,
    utcOffsetSeconds: 0,
    timezone: "GMT",
    timezoneAbbreviation: "GMT",
    elevation: 164,
    currentWeatherUnits: CurrentWeatherUnits(
      time: "iso8601",
      interval: "seconds",
      temperature: "°C",
      windspeed: "km/h",
      winddirection: "°",
      isDay: "",
      weathercode: "wmo code",
    ),
    currentWeather: CurrentWeather(
      time: "2025-03-25T05:15",
      interval: 900,
      temperature: 29.7,
      windspeed: 4.7,
      winddirection: 328,
      isDay: 1,
      weathercode: 0,
    ),
  );

  setUp(() {
    mockGetWeather = MockGetWeather();
    weatherBloc = WeatherBloc(getWeather: mockGetWeather);
  });

  tearDown(() {
    weatherBloc.close();
  });

  test('Initial state should be WeatherEmpty', () {
    expect(weatherBloc.state, WeatherEmpty());
  });

  blocTest<WeatherBloc, WeatherState>(
    'Emits [WeatherLoading, WeatherLoaded] when GetWeatherEvent succeeds',
    build: () {
      when(
        () => mockGetWeather(NoParams()),
      ).thenAnswer((_) async => Right(weather));
      return weatherBloc;
    },
    act: (bloc) => bloc.add(GetWeatherEvent()),
    expect: () => [WeatherLoading(), WeatherLoaded(weather: weather)],
    verify: (_) {
      verify(() => mockGetWeather(NoParams())).called(1);
    },
  );

  blocTest<WeatherBloc, WeatherState>(
    'Emits [WeatherLoading, WeatherError] when GetWeatherEvent fails',
    build: () {
      when(
        () => mockGetWeather(NoParams()),
      ).thenAnswer((_) async => Left(ServerFailure()));
      return weatherBloc;
    },
    act: (bloc) => bloc.add(GetWeatherEvent()),
    expect:
        () => [
          WeatherLoading(),
          WeatherError(message: "Failed to load weather"),
        ],
    verify: (_) {
      verify(() => mockGetWeather(NoParams())).called(1);
    },
  );
}