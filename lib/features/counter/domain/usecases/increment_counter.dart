import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:practice_app/core/error/failures.dart';
import 'package:practice_app/core/usecase/usecase.dart';
import 'package:practice_app/features/counter/domain/entities/counter.dart';
import 'package:practice_app/features/counter/domain/repositories/counter_repository.dart';

class IncrementCounter implements UseCase<Counter, Params> {
  final CounterRepository counterRepository;

  IncrementCounter(this.counterRepository);

  @override
  Future<Either<Failure, Counter>> call(Params params) async {
    final Counter counter = Counter(count: params.counter.count + 1);
    return await counterRepository.saveCounter(counter);
  }
}

class Params extends Equatable {
  final Counter counter;
  const Params({required this.counter});

  @override
  List<Object?> get props => [counter];
}
