import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practice_app/core/widgets/custom_button.dart';

void main() {
  testWidgets("CustomButton displays the correct text", (tester) async {
    const buttonText = "Click Me";

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            onPressed: (){}, // No action needed for this test
            text: buttonText,
          ),
        ),
      ),
    );

    // Verify the button displays the correct text
    expect(find.text(buttonText), findsOneWidget);
  });

  testWidgets("CustomButton triggers onPressed when tapped", (tester) async {
    bool pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            onPressed: () => pressed = true,
            text: "Press",
          ),
        ),
      ),
    );

    // Tap the button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify onPressed was called
    expect(pressed, isTrue);
  });

  testWidgets("CustomButton is of type ElevatedButton", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            onPressed: () {},
            text: "Test Button",
          ),
        ),
      ),
    );

    // Verify the widget is an ElevatedButton
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}