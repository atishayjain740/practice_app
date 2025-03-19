import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:practice_app/core/error/failures.dart';
import 'package:practice_app/core/usecase/usecase.dart';
import 'package:practice_app/features/counter/domain/entities/counter.dart';
import 'package:practice_app/features/counter/domain/usecases/get_counter.dart';
import 'package:practice_app/features/counter/domain/usecases/increment_counter.dart';

part 'counter_event.dart';
part 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  final GetCounter getCounter;
  final IncrementCounter incrementCounter;

  CounterBloc({required this.getCounter, required this.incrementCounter})
    : super(CounterEmpty()) {
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

    on<IncrementCountEvent>((event, emit) async {
      emit(CounterLoading());
      int? countInteger = int.tryParse(event.count);
      if (countInteger == null) {
        emit(CounterError(message: 'Could not increment. Try again'));
      } else {
        final result = await incrementCounter(
          Params(counter: Counter(count: countInteger)),
        );
        result.fold(
          (failure) =>
              emit(CounterError(message: 'Could not increment. Try again')),
          (counter) => emit(CounterLoaded(counter: counter)),
        );
      }
    });
  }
}
