import 'dart:convert';
import 'dart:io';

import 'package:practice_app/core/error/exceptions.dart';
import 'package:practice_app/core/user/model/user_model.dart';

abstract class UserLocalFileDataSource {
  Future<UserModel> saveUser(UserModel user);
  Future<UserModel> getUser(String email);
}

class UserLocalFileDataSourceImpl implements UserLocalFileDataSource {
  final File file;
  UserLocalFileDataSourceImpl({required this.file});

  @override
  Future<UserModel> getUser(String email) async {
    final users = await getAllUsers();
    UserModel user = users.firstWhere(
      (user) => user.email == email,
      orElse: () => throw FileException(),
    );
    return user;
  }

  @override
  Future<UserModel> saveUser(UserModel user) async {
    try {
      List<UserModel> users = await getAllUsers();
      users.add(user);
      await file.writeAsString(
        jsonEncode(users.map((user) => user.toJson()).toList()),
      );
      return user;
    } catch (e) {
      throw FileException();
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    if (!file.existsSync()) return [];
    final data = jsonDecode(await file.readAsString()) as List;
    return data.map((json) => UserModel.fromJson(json)).toList();
  }
}
