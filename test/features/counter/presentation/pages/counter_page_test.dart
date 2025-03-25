
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:practice_app/features/counter/domain/entities/counter.dart';
import 'package:practice_app/features/counter/presentation/bloc/counter_bloc.dart';
import 'package:practice_app/features/counter/presentation/bloc/counter_event.dart';
import 'package:practice_app/features/counter/presentation/bloc/counter_state.dart';
import 'package:practice_app/features/counter/presentation/pages/counter_page.dart';
import 'package:practice_app/core/widgets/custom_button.dart';

class MockCounterBloc extends MockBloc<CounterEvent, CounterState> implements CounterBloc{}

void main() {
  late MockCounterBloc mockCounterBloc;
  int count = 5;
  Counter counter = Counter(count: count);
  const String strInitialText = "Start searching !";
  const String strError = "Error message";
  const String strEmpty = "";

  setUp(() {
    mockCounterBloc = MockCounterBloc();
  });

  testWidgets('CounterView displays initial text when state is CounterEmpty', (WidgetTester tester) async {
    // Arrange
    when(() => mockCounterBloc.state).thenReturn(CounterEmpty());

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CounterBloc>.value(
          value: mockCounterBloc,
          child: const CounterView(),
        ),
      ),
    );

    // Wait for all animations and rendering to complete
    await tester.pumpAndSettle();

    // Assert
    expect(find.text(strInitialText), findsOneWidget);
  });

  testWidgets('CounterView displays count text when state is CounterLoaded', (WidgetTester tester) async {
    // Arrange
    when(() => mockCounterBloc.state).thenReturn(CounterLoaded(counter: counter));

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CounterBloc>.value(
          value: mockCounterBloc,
          child: const CounterView(),
        ),
      ),
    );

    // Wait for all animations and rendering to complete
    await tester.pumpAndSettle();

    // Assert
    expect(find.text(count.toString()), findsOneWidget);
  });

  testWidgets('CounterView displays circular progress indicator when state is CounterLoading', (WidgetTester tester) async {
    // Arrange
    when(() => mockCounterBloc.state).thenReturn(CounterLoading());

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CounterBloc>.value(
          value: mockCounterBloc,
          child: const CounterView(),
        ),
      ),
    );

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('CounterView displays error message when state is CounterError', (WidgetTester tester) async {
    // Arrange
    when(() => mockCounterBloc.state).thenReturn(CounterError(message: strError));

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CounterBloc>.value(
          value: mockCounterBloc,
          child: const CounterView(),
        ),
      ),
    );

    // Assert
    expect(find.text(strError), findsOneWidget);
  });

  testWidgets('CustomButton triggers GetCountEvent when pressed', (WidgetTester tester) async {
    // Arrange
    when(() => mockCounterBloc.state).thenReturn(CounterEmpty());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CounterBloc>.value(
          value: mockCounterBloc,
          child: const CounterView(),
        ),
      ),
    );

    // Act
    await tester.tap(find.byType(CustomButton));
    await tester.pump();

    // Assert
    verify(() => mockCounterBloc.add(GetCountEvent())).called(1);
  });

  testWidgets('Increment button present and calls IncrementCountEvent', (WidgetTester tester) async {
    // Arrange
    when(() => mockCounterBloc.state).thenReturn(CounterLoaded(counter: counter));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CounterBloc>.value(
          value: mockCounterBloc,
          child: const CounterView(),
        ),
      ),
    );

    // Act
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Assert
    expect(find.byIcon(Icons.add), findsOneWidget);
    verify(() => mockCounterBloc.add(IncrementCountEvent(count: count.toString()))).called(1);
  });

  testWidgets('Decrement button present and calls DecrementCountEvent', (WidgetTester tester) async {
    // Arrange
    when(() => mockCounterBloc.state).thenReturn(CounterLoaded(counter: counter));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CounterBloc>.value(
          value: mockCounterBloc,
          child: const CounterView(),
        ),
      ),
    );

    // Act
    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();

    // Assert
    expect(find.byIcon(Icons.remove), findsOneWidget);
    verify(() => mockCounterBloc.add(DecrementCountEvent(count: count.toString()))).called(1);
  });

  testWidgets('Increment button pressed with empty string when no integer value present to increment at the time of CounterEmpty state', (WidgetTester tester) async {
    // Arrange
    when(() => mockCounterBloc.state).thenReturn(CounterEmpty());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CounterBloc>.value(
          value: mockCounterBloc,
          child: const CounterView(),
        ),
      ),
    );

    // Act
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Assert
    expect(find.byIcon(Icons.add), findsOneWidget);
    verify(() => mockCounterBloc.add(IncrementCountEvent(count: strEmpty))).called(1);
  });

  testWidgets('Decrement button pressed with empty string when no integer value present to decrement at the time of CounterEmpty state', (WidgetTester tester) async {
    // Arrange
    when(() => mockCounterBloc.state).thenReturn(CounterEmpty());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CounterBloc>.value(
          value: mockCounterBloc,
          child: const CounterView(),
        ),
      ),
    );

    // Act
    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();

    // Assert
    expect(find.byIcon(Icons.remove), findsOneWidget);
    verify(() => mockCounterBloc.add(DecrementCountEvent(count: strEmpty))).called(1);
  });
}

