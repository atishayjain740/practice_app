import 'package:go_router/go_router.dart';
import 'package:practice_app/features/counter/presentation/pages/counter_page.dart';
import 'package:practice_app/features/home/presentation/pages/home.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => Home()),
    GoRoute(path: '/counter', builder: (context, state) => CounterPage()),
    // GoRoute(
    //   path: '/weather',
    //   builder: (context, state) => WeatherScreen(),
    // ),
  ],
);
