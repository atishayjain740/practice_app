import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practice_app/features/home/presentation/pages/home.dart';

void main() {
  const String strCounterTitle = "Counter";
  const String strWeatherTitle = "Weather";


  testWidgets('Home Screen renders two cards', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const Home(),
      ),
    );

    expect(find.text(strCounterTitle), findsOneWidget);
    expect(find.text(strWeatherTitle), findsOneWidget);
  });
}
