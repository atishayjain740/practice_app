part of 'counter_bloc.dart';

sealed class CounterState extends Equatable {
  const CounterState();

  @override
  List<Object> get props => [];
}

final class CounterEmpty extends CounterState {}

final class CounterLoading extends CounterState {}

final class CounterLoaded extends CounterState {
  final Counter counter;
  const CounterLoaded({required this.counter});
}

final class CounterError extends CounterState {
  final String message;
  const CounterError({required this.message});
}
