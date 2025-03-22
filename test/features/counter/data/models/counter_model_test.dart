import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:practice_app/features/counter/data/models/counter_model.dart';
import 'package:practice_app/features/counter/domain/entities/counter.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  final counterModel = CounterModel(count: 0);

  test("should be a counter entity", () {
    expect(counterModel, isA<Counter>());
  });

  group("from json", () {
    test(
      "should return a valid model when the json count is an integer",
      () async {
        final Map<String, dynamic> jsonMap = json.decode(
          fixture('counter.json'),
        );
        final result = CounterModel.fromJson(jsonMap);

        expect(result, counterModel);
      },
    );

    test(
      "should return a valid model when the json count is regarded as a double",
      () async {
        final Map<String, dynamic> jsonMap = json.decode(
          fixture('counter_double.json'),
        );
        final result = CounterModel.fromJson(jsonMap);

        expect(result, counterModel);
      },
    );

    test(
      "should return a valid model when the json count is regarded as a String",
      () async {
        final Map<String, dynamic> jsonMap = json.decode(
          fixture('counter_string.json'),
        );
        final result = CounterModel.fromJson(jsonMap);

        expect(result, counterModel);
      },
    );

    test("should return exception when the json count is invalid", () async {
      final Map<String, dynamic> jsonMap = json.decode(
        fixture('counter_invalid.json'),
      );
      expect(
        () => CounterModel.fromJson(jsonMap),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group("to json", () {
    test("should return a json map containing the proper data", () async {
      final result = counterModel.toJson();
      final Map expectedMap = {'count': 0};
      expect(result, expectedMap);
    });
  });
}
