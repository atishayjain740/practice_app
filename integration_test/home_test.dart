
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:practice_app/core/router/router.dart';
import 'package:practice_app/injection_container.dart' as di;


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  const String strHome = 'Home';
  const String strCounter = 'Counter';
  const String strWeather = 'Weather';

  setUpAll(() async {
    await di.init(); // Ensure dependencies are initialized
  });

  Widget createTestWidget() {
    return MaterialApp.router(
      routerConfig: router,
    );
  }

  void expectHome() {
    expect(find.text(strHome), findsOneWidget);
    expect(find.text(strCounter), findsOneWidget);
    expect(find.text(strWeather), findsOneWidget);
  }

  testWidgets('Home page loads correctly with all the cards. Tap on the cards to go the correct screen and come back',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    expectHome();

    // Go to counter page
    await tester.tap(find.text(strCounter));
    await tester.pumpAndSettle();
    expect(find.text(strCounter), findsOneWidget);

    // Come back to home
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expectHome();

     // Go to weather page
    await tester.tap(find.text(strWeather));
    await tester.pumpAndSettle();
    expect(find.text(strWeather), findsOneWidget);

    // Come back to home
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expectHome();
    
  });
}