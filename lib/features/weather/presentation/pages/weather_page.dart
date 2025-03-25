import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:practice_app/core/widgets/custom_button.dart';
import 'package:practice_app/core/widgets/display_text.dart';
import 'package:practice_app/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:practice_app/features/weather/presentation/bloc/weather_event.dart';
import 'package:practice_app/features/weather/presentation/bloc/weather_state.dart';
import 'package:practice_app/injection_container.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => sl<WeatherBloc>(),
      child: WeatherView(),
    );
  }
}

class WeatherView extends StatelessWidget {
  final String _strWeather = 'Weather';
  final String _strInitialText = "No weather data !";
  final String _strRandomBtnText = "Get weather data";

  const WeatherView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).pop(),
        ),
        title: Text(_strWeather),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                child: Align(
                  alignment: Alignment.center,
                  child: BlocBuilder<WeatherBloc, WeatherState>(
                    builder: (context, state) {
                      return _buildWeatherData(state);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 50),
              CustomButton(
                onPressed: () {
                  context.read<WeatherBloc>().add(GetWeatherEvent());
                },
                text: _strRandomBtnText,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherData(WeatherState state) {
    switch (state) {
      case WeatherEmpty():
        return DisplayText(text: _strInitialText);
      case WeatherError():
        return DisplayText(text: state.message);
      case WeatherLoading():
        return SizedBox(
          height: 50,
          width: 50,
          child: Align(
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          ),
        );
      case WeatherLoaded():
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DisplayText(
              text:
                  "${state.weather.currentWeather!.temperature} ${state.weather.currentWeatherUnits!.temperature}",
            ),
            DisplayText(
              text: getStrTimeOfDay(state.weather.currentWeather!.isDay!),
            ),
          ],
        );
      default:
        return Container();
    }
  }

  String getStrTimeOfDay(int isDay) {
    return isDay == 0 ? "Night Time" : 'Day Time';
  }
}
