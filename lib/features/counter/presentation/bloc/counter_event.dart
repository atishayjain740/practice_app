

import 'package:equatable/equatable.dart';

class CounterEvent extends Equatable {
  const CounterEvent();

  @override
  List<Object> get props => [];
}

class GetCountEvent extends CounterEvent {}

class GetCachedCountEvent extends CounterEvent {}

class IncrementCountEvent extends CounterEvent {
  final String count;
  const IncrementCountEvent({required this.count});
}

class DecrementCountEvent extends CounterEvent {
  final String count;
  const DecrementCountEvent({required this.count});
}
