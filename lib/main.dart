import 'package:flutter/material.dart';
import 'package:practice_app/core/constants/colors.dart';
import 'package:practice_app/features/counter/presentation/pages/counter_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      brightness: MediaQuery.platformBrightnessOf(context),
      seedColor: lightGreen,
      primary: lightGreen,
      onPrimary: white
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Practice App',
      theme: ThemeData(
        colorScheme: colorScheme,
        appBarTheme: AppBarTheme(backgroundColor: colorScheme.primary, foregroundColor: colorScheme.onPrimary),
        elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary, // Default background color
        foregroundColor: colorScheme.onPrimary, // Text color
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        elevation: 5, // Shadow effect
      ),
    ),
      ),
      home: const CounterPage(),
    );
  }
}
