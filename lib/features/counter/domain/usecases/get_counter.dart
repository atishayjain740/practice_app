import 'package:dartz/dartz.dart';
import 'package:practice_app/core/error/failures.dart';
import 'package:practice_app/core/usecase/usecase.dart';
import 'package:practice_app/features/counter/domain/entities/counter.dart';
import 'package:practice_app/features/counter/domain/repositories/counter_repository.dart';

class GetCounter implements UseCase<Counter, NoParams> {
  final CounterRepository counterRepository;

  GetCounter(this.counterRepository);

  @override
  Future<Either<Failure, Counter>> call(NoParams params) async {
    return await counterRepository.getCounter();
  }
}


