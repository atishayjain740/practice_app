import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practice_app/core/widgets/display_text.dart';

void main() {
  testWidgets("DisplayText widget shows the correct text", (tester) async {
    const testText = "Hello";

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DisplayText(text: testText),
        ),
      ),
    );

    // Verify the text is displayed
    expect(find.text(testText), findsOneWidget);
  });

  testWidgets("DisplayText widget has the correct font size", (tester) async {
    const testText = "Styled Text";

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DisplayText(text: testText),
        ),
      ),
    );

    final textWidget = tester.widget<Text>(find.text(testText));

    // Verify font size is 35
    expect(textWidget.style?.fontSize, 35);
  });
}