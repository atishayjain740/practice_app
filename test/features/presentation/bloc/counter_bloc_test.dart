import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:practice_app/core/error/failures.dart';
import 'package:practice_app/core/usecase/usecase.dart';
import 'package:practice_app/features/counter/domain/entities/counter.dart';
import 'package:practice_app/features/counter/domain/usecases/get_counter.dart';
import 'package:practice_app/features/counter/domain/usecases/increment_counter.dart';
import 'package:practice_app/features/counter/presentation/bloc/counter_bloc.dart';

import 'counter_bloc_test.mocks.dart';

@GenerateMocks([GetCounter, IncrementCounter])
void main() {
  late CounterBloc counterBloc;
  late MockGetCounter mockGetCounter;
  late MockIncrementCounter mockIncrementCounter;

  const int count = 0;
  Counter counter = Counter(count: count);
  setUp(() {
    mockGetCounter = MockGetCounter();
    mockIncrementCounter = MockIncrementCounter();
    counterBloc = CounterBloc(
      getCounter: mockGetCounter,
      incrementCounter: mockIncrementCounter,
    );
  });

  tearDown(() {
    counterBloc.close();
  });

  test('Initial state should be CounterEmpty', () {
    expect(counterBloc.state, CounterEmpty());
  });

  blocTest<CounterBloc, CounterState>(
    'Emits [CounterLoading, CounterLoaded] when GetCounterEvent succeeds',
    build: () {
      when(
        mockGetCounter(NoParams()),
      ).thenAnswer((_) async => Right(Counter(count: 0)));
      return counterBloc;
    },
    act: (bloc) => bloc.add(GetCountEvent()),
    expect: () => [CounterLoading(), CounterLoaded(counter: counter)],
    verify: (_) {
      verify(mockGetCounter(NoParams())).called(1);
    },
  );

  blocTest<CounterBloc, CounterState>(
    'Emits [CounterLoading, CounterError] when GetCounterEvent fails',
    build: () {
      when(
        mockGetCounter(NoParams()),
      ).thenAnswer((_) async => Left(ServerFailure()));
      return counterBloc;
    },
    act: (bloc) => bloc.add(GetCountEvent()),
    expect:
        () => [
          CounterLoading(),
          CounterError(message: "Failed to load counter"),
        ],
    verify: (_) {
      verify(mockGetCounter(NoParams())).called(1);
    },
  );

  group('increment count', () {
    const expectedCounter = Counter(count: count + 1);
    blocTest<CounterBloc, CounterState>(
      'Emits [CounterLoading, CounterLoaded] when IncrementCount succeeds',
      build: () {
        when(
          mockIncrementCounter(any),
        ).thenAnswer((_) async => Right(expectedCounter));
        return counterBloc;
      },
      act: (bloc) => bloc.add(IncrementCountEvent(count: count.toString())),
      expect: () => [CounterLoading(), CounterLoaded(counter: expectedCounter)],
      verify: (_) {
        verify(mockIncrementCounter(Params(counter: counter))).called(1);
      },
    );

    blocTest<CounterBloc, CounterState>(
      'Emits [CounterLoading, CounterError] when IncrementCount fails',
      build: () {
        when(
          mockIncrementCounter(any),
        ).thenAnswer((_) async => Left(CacheFailure()));
        return counterBloc;
      },
      act: (bloc) => bloc.add(IncrementCountEvent(count: count.toString())),
      expect:
          () => [
            CounterLoading(),
            CounterError(message: "Failed to increment."),
          ],
      verify: (_) {
        verify(mockIncrementCounter(Params(counter: counter))).called(1);
      },
    );
  });
}
