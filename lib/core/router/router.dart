import 'package:go_router/go_router.dart';
import 'package:practice_app/core/user/user_session_manager.dart';
import 'package:practice_app/features/auth/presentation/pages/sign_in_page.dart';
import 'package:practice_app/features/auth/presentation/pages/sign_up_page.dart';
import 'package:practice_app/features/counter/presentation/pages/counter_page.dart';
import 'package:practice_app/features/home/presentation/pages/home.dart';
import 'package:practice_app/features/weather/presentation/pages/weather_page.dart';
import 'package:practice_app/injection_container.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/signin', builder: (context, state) => SignInPage()),
    GoRoute(path: '/signup', builder: (context, state) => SignUpPage()),
    GoRoute(path: '/', builder: (context, state) => Home(), redirect: (context, state) {
    final userSession = sl<UserSessionManager>();
    return userSession.isLoggedIn ? null : '/login';
  },),
    GoRoute(path: '/counter', builder: (context, state) => CounterPage()),
    GoRoute(
      path: '/weather',
      builder: (context, state) => WeatherPage(),
    ),
  ],
);
