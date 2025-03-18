import 'dart:convert';

import 'package:practice_app/core/error/exceptions.dart';
import 'package:practice_app/features/counter/data/models/counter_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CounterLocalDataSource {
  Future<CounterModel> getCounter();
  Future<void> cacheCounter(CounterModel counterToCache);
}

const cachedCounter = 'CACHED_COUNTER';

class CounterLocalDataSourceImpl implements CounterLocalDataSource {
  final SharedPreferences sharedPreferences;

  const CounterLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheCounter(CounterModel counterToCache) async {
    String jsonString = jsonEncode(counterToCache.toJson());
    sharedPreferences.setString(cachedCounter, jsonString);
  }

  @override
  Future<CounterModel> getCounter() {
    final jsonString = sharedPreferences.getString(cachedCounter);
    if (jsonString != null) {
      return Future.value(CounterModel.fromJson(json.decode(jsonString)));
    } else {
      throw (CacheException());
    }
  }
}
