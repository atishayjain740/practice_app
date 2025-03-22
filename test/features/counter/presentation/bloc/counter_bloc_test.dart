import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:practice_app/core/constants/dummy_url.dart';
import 'package:practice_app/core/error/failures.dart';
import 'package:practice_app/core/usecase/usecase.dart';
import 'package:practice_app/features/counter/domain/entities/counter.dart';
import 'package:practice_app/features/counter/domain/usecases/decrement_counter.dart';
import 'package:practice_app/features/counter/domain/usecases/get_cached_counter.dart';
import 'package:practice_app/features/counter/domain/usecases/get_counter.dart';
import 'package:practice_app/features/counter/domain/usecases/increment_counter.dart'
    as ic;
import 'package:practice_app/features/counter/presentation/bloc/counter_bloc.dart';
import 'package:practice_app/features/counter/presentation/bloc/counter_event.dart';
import 'package:practice_app/features/counter/presentation/bloc/counter_state.dart';


class MockGetCounter extends Mock implements GetCounter{}
class MockGetCachedCounter extends Mock implements GetCachedCounter{}
class MockIncrementCounter extends Mock implements ic.IncrementCounter{}
class MockDecrementCounter extends Mock implements DecrementCounter{}

void main() {
  late CounterBloc counterBloc;
  late MockGetCounter mockGetCounter;
  late MockGetCachedCounter mockGetCachedCounter;
  late MockIncrementCounter mockIncrementCounter;
  late MockDecrementCounter mockDecrementCounter;

  const int count = 0;
  Counter counter = Counter(count: count);

  setUpAll((){
    registerFallbackValue(Uri.parse(dummyUrl));
  });

  setUp(() {
    mockGetCounter = MockGetCounter();
    mockIncrementCounter = MockIncrementCounter();
    mockDecrementCounter = MockDecrementCounter();
    mockGetCachedCounter = MockGetCachedCounter();
    counterBloc = CounterBloc(
      getCounter: mockGetCounter,
      incrementCounter: mockIncrementCounter,
      decrementCounter: mockDecrementCounter,
      getCachedCounter: mockGetCachedCounter,
    );
  });

  tearDown(() {
    counterBloc.close();
  });

  test('Initial state should be CounterEmpty', () {
    expect(counterBloc.state, CounterEmpty());
  });

  group('initial count', () {
    blocTest<CounterBloc, CounterState>(
      'Emits [CounterLoading, CounterEmpty] when GetCachedCounterEvent fails',
      build: () {
        when(
          () => mockGetCachedCounter(NoParams()),
        ).thenAnswer((_) async => Left(CacheFailure()));
        return counterBloc;
      },
      act: (bloc) => bloc.add(GetCachedCountEvent()),
      expect: () => [CounterLoading(), CounterEmpty()],
      verify: (_) {
        verify(() => mockGetCachedCounter(NoParams())).called(1);
      },
    );

    blocTest<CounterBloc, CounterState>(
      'Emits [CounterLoading, CounterLoaded] when GetCachedCounterEvent succeeds',
      build: () {
        when(
          () => mockGetCachedCounter(NoParams()),
        ).thenAnswer((_) async => Right(counter));
        return counterBloc;
      },
      act: (bloc) => bloc.add(GetCachedCountEvent()),
      expect: () => [CounterLoading(), CounterLoaded(counter: counter)],
      verify: (_) {
        verify(() => mockGetCachedCounter(NoParams())).called(1);
      },
    );
  });

  blocTest<CounterBloc, CounterState>(
    'Emits [CounterLoading, CounterLoaded] when counter found in cache',
    build: () {
      when(
        () => mockGetCounter(NoParams()),
      ).thenAnswer((_) async => Right(Counter(count: 0)));
      return counterBloc;
    },
    act: (bloc) => bloc.add(GetCountEvent()),
    expect: () => [CounterLoading(), CounterLoaded(counter: counter)],
    verify: (_) {
      verify(() => mockGetCounter(NoParams())).called(1);
    },
  );

  blocTest<CounterBloc, CounterState>(
    'Emits [CounterLoading, CounterLoaded] when GetCounterEvent succeeds',
    build: () {
      when(
        () => mockGetCounter(NoParams()),
      ).thenAnswer((_) async => Right(Counter(count: 0)));
      return counterBloc;
    },
    act: (bloc) => bloc.add(GetCountEvent()),
    expect: () => [CounterLoading(), CounterLoaded(counter: counter)],
    verify: (_) {
      verify(() => mockGetCounter(NoParams())).called(1);
    },
  );

  blocTest<CounterBloc, CounterState>(
    'Emits [CounterLoading, CounterError] when GetCounterEvent fails',
    build: () {
      when(
        () => mockGetCounter(NoParams()),
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
      verify(() => mockGetCounter(NoParams())).called(1);
    },
  );

  group('increment count', () {
    const expectedCounter = Counter(count: count + 1);
    blocTest<CounterBloc, CounterState>(
      'Emits [CounterLoading, CounterLoaded] when IncrementCount succeeds',
      build: () {
        when(
          () => mockIncrementCounter(ic.Params(counter: counter)),
        ).thenAnswer((_) async => Right(expectedCounter));
        return counterBloc;
      },
      act: (bloc) => bloc.add(IncrementCountEvent(count: count.toString())),
      expect: () => [CounterLoading(), CounterLoaded(counter: expectedCounter)],
      verify: (_) {
        verify(() => mockIncrementCounter(ic.Params(counter: counter))).called(1);
      },
    );

    blocTest<CounterBloc, CounterState>(
      'Emits [CounterLoading, CounterError] when IncrementCount fails',
      build: () {
        when(
          () => mockIncrementCounter(ic.Params(counter: counter)),
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
        verify(() => mockIncrementCounter(ic.Params(counter: counter))).called(1);
      },
    );
  });

  group('deccrement count', () {
    const expectedCounter = Counter(count: count - 1);
    blocTest<CounterBloc, CounterState>(
      'Emits [CounterLoading, CounterLoaded] when DecrementCount succeeds',
      build: () {
        when(
          () => mockDecrementCounter(Params(counter: counter)),
        ).thenAnswer((_) async => Right(expectedCounter));
        return counterBloc;
      },
      act: (bloc) => bloc.add(DecrementCountEvent(count: count.toString())),
      expect: () => [CounterLoading(), CounterLoaded(counter: expectedCounter)],
      verify: (_) {
        verify(() => mockDecrementCounter(Params(counter: counter))).called(1);
      },
    );

    blocTest<CounterBloc, CounterState>(
      'Emits [CounterLoading, CounterError] when DecrementCount fails',
      build: () {
        when(
          () => mockDecrementCounter(Params(counter: counter)),
        ).thenAnswer((_) async => Left(CacheFailure()));
        return counterBloc;
      },
      act: (bloc) => bloc.add(DecrementCountEvent(count: count.toString())),
      expect:
          () => [
            CounterLoading(),
            CounterError(message: "Failed to decrement."),
          ],
      verify: (_) {
        verify(() => mockDecrementCounter(Params(counter: counter))).called(1);
      },
    );
  });
}
