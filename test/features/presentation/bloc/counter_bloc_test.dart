import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:practice_app/core/error/failures.dart';
import 'package:practice_app/core/usecase/usecase.dart';
import 'package:practice_app/features/counter/domain/entities/counter.dart';
import 'package:practice_app/features/counter/domain/usecases/get_counter.dart';
import 'package:practice_app/features/counter/presentation/bloc/counter_bloc.dart';

import 'counter_bloc_test.mocks.dart';

@GenerateMocks([GetCounter])
void main() {
  late CounterBloc counterBloc;
  late MockGetCounter mockGetCounter;
  Counter counter = Counter(count: 0);
  setUp(() {
    mockGetCounter = MockGetCounter();
    counterBloc = CounterBloc(getCounter: mockGetCounter);
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
}
