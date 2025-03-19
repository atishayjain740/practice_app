import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:practice_app/core/error/failures.dart';
import 'package:practice_app/core/usecase/usecase.dart';
import 'package:practice_app/features/counter/domain/entities/counter.dart';
import 'package:practice_app/features/counter/domain/usecases/decrement_counter.dart';
import 'package:practice_app/features/counter/domain/usecases/get_cached_counter.dart';
import 'package:practice_app/features/counter/domain/usecases/get_counter.dart';
import 'package:practice_app/features/counter/domain/usecases/increment_counter.dart'
    as ic;

part 'counter_event.dart';
part 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  final GetCounter getCounter;
  final ic.IncrementCounter incrementCounter;
  final DecrementCounter decrementCounter;
  final GetCachedCounter getCachedCounter;

  CounterBloc({
    required this.getCounter,
    required this.incrementCounter,
    required this.decrementCounter,
    required this.getCachedCounter,
  }) : super(CounterEmpty()) {
    on<GetCountEvent>((event, emit) async {
      emit(CounterLoading());
      final result = await getCounter(NoParams());
      result.fold(
        (failure) => emit(
          CounterError(
            message:
                failure is ServerFailure
                    ? "Failed to load counter. Server Exception"
                    : "Faild to load counter. Cache Exception",
          ),
        ),
        (counter) => emit(CounterLoaded(counter: counter)),
      );
    });

    on<GetCachedCountEvent>((event, emit) async {
      emit(CounterLoading());
      final result = await getCachedCounter(NoParams());
      result.fold(
        (failure) => emit(CounterEmpty()),
        (counter) => emit(CounterLoaded(counter: counter)),
      );
    });

    on<IncrementCountEvent>((event, emit) async {
      emit(CounterLoading());
      int? countInteger = int.tryParse(event.count);
      if (countInteger == null) {
        emit(CounterError(message: 'Could not increment. Try searching'));
      } else {
        final result = await incrementCounter(
          ic.Params(counter: Counter(count: countInteger)),
        );
        result.fold(
          (failure) =>
              emit(CounterError(message: 'Could not increment. Try searching')),
          (counter) => emit(CounterLoaded(counter: counter)),
        );
      }
    });

    on<DecrementCountEvent>((event, emit) async {
      emit(CounterLoading());
      int? countInteger = int.tryParse(event.count);
      if (countInteger == null) {
        emit(CounterError(message: 'Could not decrement. Try searching'));
      } else {
        final result = await decrementCounter(
          Params(counter: Counter(count: countInteger)),
        );
        result.fold(
          (failure) =>
              emit(CounterError(message: 'Could not decrement. Try searching')),
          (counter) => emit(CounterLoaded(counter: counter)),
        );
      }
    });
  }
}
