import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:practice_app/core/user/user_session_manager.dart';
import 'package:practice_app/core/widgets/display_text.dart';
import 'package:practice_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:practice_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:practice_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:practice_app/features/home/presentation/widget/custom_card.dart';
import 'package:practice_app/injection_container.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => sl<AuthBloc>()),
        Provider<UserSessionManager>(
          create:
              (context) => sl<UserSessionManager>(), // Your singleton instance
        ),
      ],
      child: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  final String _strHomeTitle = 'Home';
  final String _strCounter = 'Counter';
  final String _strWeather = 'Weather';
  final String _strCounterDescription =
      'Counter feature lets you get a random counter and increment and decrement on it. It also saves your data. It is also offline compatible.';
  final String _strWeatherDescription = 'Weather feature gives you the tempearture. It also saves your data. It shows the last updated weather.';
  final String _strSignOut = 'Sign Out';
  final String _strCancel = 'Cancel';
  final String _strSignOutConfirmation = 'Are you sure you want to sign out?';

  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final String strHeading =
      'Hi ${context.read<UserSessionManager>().currentUser!.firstName}, Explore the features crafted for you';
    return Scaffold(
      appBar: AppBar(
        title: Text(_strHomeTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Align(
          alignment: Alignment.center,
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthSignOut) {
                GoRouter.of(context).go('/signin');
              }
            },
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  DisplayText(text: strHeading),
                  const SizedBox(height: 20),
                  CustomCard(
                    title: _strCounter,
                    description: _strCounterDescription,
                    onPressed: () => GoRouter.of(context).push('/counter'),
                  ),
                  const SizedBox(height: 20),
                  CustomCard(
                    title: _strWeather,
                    description: _strWeatherDescription,
                    onPressed: () => GoRouter.of(context).push('/weather'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(_strSignOut),
            content: Text(_strSignOutConfirmation),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(_strCancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(_strSignOut),
              ),
            ],
          ),
    );

    if (shouldLogout == true && context.mounted) {
      context.read<AuthBloc>().add(SignOutEvent());
    }
  }
}
