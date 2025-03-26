import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:practice_app/core/user/model/user_model.dart';
import 'package:practice_app/core/user/entity/user.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  UserModel userModel = UserModel(
    firstName: 'testf',
    lastName: 'testl',
    email: 'test@test.com'
    );

  test("should be a user entity", () {
    expect(userModel, isA<User>());
  });

  group('from json', () {
    test("should return a valid model when the json is correct", () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture('user.json'));
      final result = UserModel.fromJson(jsonMap);

      expect(result, isInstanceOf<UserModel>());
    });

    test("should return exception when the json is incorrect", () async {
      final Map<String, dynamic> jsonMap = json.decode(
        fixture('user_invalid.json'),
      );
      expect(() => UserModel.fromJson(jsonMap), throwsA(isA<TypeError>()));
    });
  });

  group('to json', () {
    test("should return a json map containing the proper data", () async {
      final result = userModel.toJson();
      final Map<String, dynamic> expectedMap = json.decode(fixture('user.json'));
      expect(result, expectedMap);
    });
  });
}
