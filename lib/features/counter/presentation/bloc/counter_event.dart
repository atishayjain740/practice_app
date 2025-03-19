part of 'counter_bloc.dart';

sealed class CounterEvent extends Equatable {
  const CounterEvent();

  @override
  List<Object> get props => [];
}

class GetCountEvent extends CounterEvent {}

class IncrementCountEvent extends CounterEvent {
  final String count;
  const IncrementCountEvent({required this.count});
}

class DecrementCountEvent extends CounterEvent {
  final String count;
  const DecrementCountEvent({required this.count});
}
