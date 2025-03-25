import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:practice_app/features/weather/data/models/weather_model.dart';
import 'package:practice_app/features/weather/domain/entities/weather.dart';
import 'package:practice_app/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:practice_app/features/weather/presentation/bloc/weather_event.dart';
import 'package:practice_app/features/weather/presentation/bloc/weather_state.dart';
import 'package:practice_app/features/weather/presentation/pages/weather_page.dart';

import '../../fixtures/fixture_reader.dart';

class MockWeatherBloc extends MockBloc<WeatherEvent, WeatherState>
    implements WeatherBloc {}

void main() {
  late MockWeatherBloc mockWeatherBloc;
  final String strInitialText = "No weather data !";
  final String strErrorMessage = "Error message";
  final String strValidWeatherFixtureFileName = 'weather.json';
  final Weather weather = WeatherModel.fromJson(
    json.decode(fixture(strValidWeatherFixtureFileName)),
  );
  setUp(() {
    mockWeatherBloc = MockWeatherBloc();
  });

  testWidgets('WeatherView displays initial text when state is WeatherEmpty', (
    WidgetTester tester,
  ) async {
    // Arrange
    when(() => mockWeatherBloc.state).thenReturn(WeatherEmpty());

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<WeatherBloc>.value(
          value: mockWeatherBloc,
          child: const WeatherView(),
        ),
      ),
    );

    // Wait for all animations and rendering to complete
    await tester.pumpAndSettle();

    // Assert
    expect(find.text(strInitialText), findsOneWidget);
  });

  testWidgets('WeatherView displays temperature text when state is WeatherLoaded', (WidgetTester tester) async {
    // Arrange
    when(() => mockWeatherBloc.state).thenReturn(WeatherLoaded(weather: weather));

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<WeatherBloc>.value(
          value: mockWeatherBloc,
          child: const WeatherView(),
        ),
      ),
    );

    // Wait for all animations and rendering to complete
    await tester.pumpAndSettle();

    // Assert
    String expectedString = "${weather.currentWeather!.temperature} ${weather.currentWeatherUnits!.temperature}";
    expect(find.text(expectedString), findsOneWidget);
  });

  testWidgets('WeatherView displays circular progress indicator when state is WeatherLoading', (WidgetTester tester) async {
    // Arrange
    when(() => mockWeatherBloc.state).thenReturn(WeatherLoading());

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<WeatherBloc>.value(
          value: mockWeatherBloc,
          child: const WeatherView(),
        ),
      ),
    );

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('WeatherView displays error message when state is WeatherError', (WidgetTester tester) async {
    // Arrange
    when(() => mockWeatherBloc.state).thenReturn(WeatherError(message: strErrorMessage));

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<WeatherBloc>.value(
          value: mockWeatherBloc,
          child: const WeatherView(),
        ),
      ),
    );

    // Assert
    expect(find.text(strErrorMessage), findsOneWidget);
  });
}
