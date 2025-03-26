import 'dart:convert';

import 'package:practice_app/core/error/exceptions.dart';
import 'package:practice_app/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserLocalCacheDataSource {
  Future<UserModel> getUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearCache();
}

const String strCachedUser = 'CACHED_USER';

class UserLocalCacheDataSourceImpl implements UserLocalCacheDataSource {
  final SharedPreferences sharedPreferences;

  UserLocalCacheDataSourceImpl({required this.sharedPreferences});
  @override
  Future<void> cacheUser(UserModel user) async {
    String jsonString = jsonEncode(user.toJson());
    sharedPreferences.setString(strCachedUser, jsonString);
  }

  @override
  Future<UserModel> getUser() {
    final jsonString = sharedPreferences.getString(strCachedUser);
    if (jsonString != null) {
      return Future.value(UserModel.fromJson(json.decode(jsonString)));
    } else {
      throw (CacheException());
    }
  }

  @override
  Future<void> clearCache() async {
    final result = await sharedPreferences.remove(strCachedUser);
    if (!result) {
      throw (CacheException());
    }
  }

}