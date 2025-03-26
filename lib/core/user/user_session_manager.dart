import 'dart:convert';
import 'package:practice_app/core/user/entity/user.dart';
import 'package:practice_app/core/user/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _cachedUserKey = 'CACHED_USER';

class UserSessionManager {
  final SharedPreferences _prefs;
  User? _user;

  UserSessionManager(this._prefs);

  Future<void> init() async {
    await _loadUser();
  }

  Future<void> _loadUser() async {
    final json = _prefs.getString(_cachedUserKey);
    _user = json != null ? UserModel.fromJson(jsonDecode(json)) : null;
  }

  User? get currentUser => _user;
  bool get isLoggedIn => _user != null;

  Future<void> logout() async {
    await _prefs.remove(_cachedUserKey);
    _user = null;
  }
}