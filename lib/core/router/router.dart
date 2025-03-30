import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:practice_app/core/user/user_session_manager.dart';
import 'package:practice_app/features/auth/presentation/pages/sign_in_page.dart';
import 'package:practice_app/features/auth/presentation/pages/sign_up_page.dart';
import 'package:practice_app/features/counter/presentation/pages/counter_page.dart';
import 'package:practice_app/features/home/presentation/pages/home_page.dart';
import 'package:practice_app/features/notes/presentation/bloc/notes_bloc.dart';
import 'package:practice_app/features/notes/presentation/bloc/notes_event.dart';
import 'package:practice_app/features/notes/presentation/pages/add_note_page.dart';
import 'package:practice_app/features/notes/presentation/pages/notes_page.dart';
import 'package:practice_app/features/weather/presentation/pages/weather_page.dart';
import 'package:practice_app/injection_container.dart';

const String homeRoute = '/';
const String signinRoute = '/signin';
const String signupRoute = '/signup';
const String counterRoute = '/counter';
const String weatherRoute = '/weather';
const String notesRoute = '/notes';
const String addnoteRoute = '/addnote';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: signinRoute, builder: (context, state) => SignInPage()),
    GoRoute(path: signupRoute, builder: (context, state) => SignUpPage()),
    GoRoute(
      path: homeRoute,
      builder: (context, state) => HomePage(),
      redirect: (context, state) {
        final userSession = sl<UserSessionManager>();
        return userSession.isLoggedIn ? null : signinRoute;
      },
    ),
    GoRoute(path: counterRoute, builder: (context, state) => CounterPage()),
    GoRoute(path: weatherRoute, builder: (context, state) => WeatherPage()),
    ShellRoute(
      builder: (context, state, child) {
        return BlocProvider(
          create: (_) => sl<NotesBloc>()..add(GetAllNotesEvent()),
          child: child,
        );
      },
      routes: [
        GoRoute(path: notesRoute, builder: (context, state) => NotesPage()),
        GoRoute(path: addnoteRoute, builder: (context, state) => AddNotePage()),
      ],
    ),
  ],
);
