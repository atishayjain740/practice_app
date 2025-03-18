import 'package:practice_app/features/counter/data/models/counter_model.dart';
import 'package:practice_app/features/counter/domain/entities/counter.dart';

abstract class CounterLocalDataSource {
  Future<Counter> getCounter();
  Future<void> cacheCounter(Counter counterToCache);
}
