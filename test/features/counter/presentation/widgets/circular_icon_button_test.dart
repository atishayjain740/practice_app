import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practice_app/features/counter/presentation/widgets/circular_icon_button.dart';

void main() {
  testWidgets("CircularIconButton displays the correct icon", (tester) async {
    const testIcon = Icons.add;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CircularIconButton(
            onPressed: (){}, // No action needed for this test
            icon: testIcon,
          ),
        ),
      ),
    );

    // Verify the icon is displayed
    expect(find.byIcon(testIcon), findsOneWidget);
  });

  testWidgets("CircularIconButton triggers onPressed when tapped", (tester) async {
    bool pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CircularIconButton(
            onPressed: () => pressed = true,
            icon: Icons.add,
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

  testWidgets("CircularIconButton has circular shape and padding", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CircularIconButton(
            onPressed: () {},
            icon: Icons.add,
          ),
        ),
      ),
    );

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    // Verify shape is circular
    expect(button.style?.shape, isA<WidgetStateProperty<OutlinedBorder>>());

    // Verify padding
    expect(button.style?.padding?.resolve({}), const EdgeInsets.all(20));
  });
}