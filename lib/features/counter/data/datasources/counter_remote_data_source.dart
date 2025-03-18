import 'package:practice_app/features/counter/domain/entities/counter.dart';

abstract class CounterRemoteDataSource {
  Future<Counter> getCounter();
}
