import 'dart:convert';

import 'package:practice_app/core/error/exceptions.dart';
import 'package:practice_app/features/counter/data/models/counter_model.dart';
import 'package:http/http.dart' as http;

abstract class CounterRemoteDataSource {
  Future<CounterModel> getCounter();
}

class CounterRemoteDataSourceImpl implements CounterRemoteDataSource {
  final http.Client client;

  CounterRemoteDataSourceImpl({required this.client});

  @override
  Future<CounterModel> getCounter() async {
    final response = await client.get(
      Uri.parse(
        'https://www.randomnumberapi.com/api/v1.0/random?min=1&max=100&count=1',
      ),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> map = {};
      dynamic data = json.decode(response.body);
      if (data is List) {
        map = {'count': data[0]};
      } else {
        map = data;
      }

      return CounterModel.fromJson(map);
    } else {
      throw ServerException();
    }
  }
}
