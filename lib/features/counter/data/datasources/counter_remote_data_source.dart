import 'package:practice_app/features/counter/data/models/counter_model.dart';

abstract class CounterRemoteDataSource {
  Future<CounterModel> getCounter();
}
