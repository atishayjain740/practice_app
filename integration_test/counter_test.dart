import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:practice_app/features/counter/domain/entities/counter.dart';
import 'package:practice_app/features/counter/presentation/bloc/counter_bloc.dart';
import 'package:practice_app/features/counter/presentation/bloc/counter_state.dart';
import 'package:practice_app/features/counter/presentation/pages/counter_page.dart';
import 'package:practice_app/injection_container.dart' as di;

class MockCounterBloc extends Mock implements CounterBloc {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late CounterBloc mockCounterBloc;

  setUpAll(() async {
    await di.init(); // Ensure dependencies are initialized
    mockCounterBloc = MockCounterBloc();
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: BlocProvider<CounterBloc>.value(
        value: mockCounterBloc,
        child: const CounterPage(),
      ),
    );
  }

  testWidgets('CounterPage starts with initial state and updates UI correctly',
      (WidgetTester tester) async {
    // Arrange: Start with an empty state
    when(() => mockCounterBloc.state).thenReturn(CounterEmpty());

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Act: Tap "Get random counter" button
    await tester.tap(find.text("Get random counter"));
    await tester.pumpAndSettle();

    // Extract displayed counter value dynamically
    final counterFinder = find.byType(Text);
    final textWidgets = tester.widgetList<Text>(counterFinder);

    String? counterText;
    for (var textWidget in textWidgets) {
      if (int.tryParse(textWidget.data ?? '') != null) {
        counterText = textWidget.data!;
        break;
      }
    }

    // Ensure a valid counter value was found
    expect(counterText, isNotNull);
    final int initialCounter = int.parse(counterText!);

    // Arrange: Mock Increment state
    whenListen(
      mockCounterBloc,
      Stream<CounterState>.fromIterable([
        CounterLoaded(counter: Counter(count: initialCounter + 1)),
      ]),
      initialState: CounterLoaded(counter: Counter(count: initialCounter)),
    );

    // Act: Tap increment button
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Assert: Counter should be incremented
    expect(find.text("${initialCounter + 1}"), findsOneWidget);

    // Arrange: Mock Decrement state
    whenListen(
      mockCounterBloc,
      Stream<CounterState>.fromIterable([
        CounterLoaded(counter: Counter(count: initialCounter)),
      ]),
      initialState: CounterLoaded(counter: Counter(count: initialCounter + 1)),
    );

    // Act: Tap decrement button
    await tester.tap(find.byIcon(Icons.remove));
    await tester.pumpAndSettle();

    // Assert: Counter should be decremented back to original value
    expect(find.text("$initialCounter"), findsOneWidget);
  });
}