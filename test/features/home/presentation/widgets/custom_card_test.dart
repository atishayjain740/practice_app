import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practice_app/features/home/presentation/widget/custom_card.dart';

void main() {
  testWidgets('CustomCard displays the correct title', (WidgetTester tester) async {
    const testTitle = 'Test Card';

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomCard(
            title: testTitle,
            onPressed: () {},
          ),
        ),
      ),
    );

    // Verify that the title is displayed
    expect(find.text(testTitle), findsOneWidget);
  });

  testWidgets('Tapping CustomCard triggers onPressed callback', (WidgetTester tester) async {
    bool wasTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomCard(
            title: 'Tap Me',
            onPressed: () {
              wasTapped = true;
            },
          ),
        ),
      ),
    );

    // Tap the card
    await tester.tap(find.byType(InkWell));
    await tester.pump();

    // Verify that onPressed was triggered
    expect(wasTapped, isTrue);
  });
}