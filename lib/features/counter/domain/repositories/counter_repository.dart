import 'package:dartz/dartz.dart';
import 'package:practice_app/core/error/failures.dart';
import 'package:practice_app/features/counter/domain/entities/counter.dart';

abstract class CounterRepository {
  Future<Either<Failure, Counter>> getCounter();
}
