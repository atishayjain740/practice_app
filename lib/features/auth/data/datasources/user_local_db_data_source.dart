import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:practice_app/core/error/exceptions.dart';
import 'package:practice_app/core/user/model/user_model.dart';

abstract class UserLocalDBDataSource {
  Future<UserModel> saveUser(UserModel user);
  Future<UserModel> getUser(String email);
}

const String userTable = 'users';
const String userTableCreateQuery = '''
  CREATE TABLE $userTable (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    firstname TEXT,
    lastname TEXT,
    email TEXT UNIQUE
  )
''';

Future<Database> initUserDb() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'users.db');
  return await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      await db.execute(userTableCreateQuery);
    },
  );
}

class UserLocalDatabaseDataSourceImpl implements UserLocalDBDataSource {
  final Database database;

  UserLocalDatabaseDataSourceImpl({required this.database});

  @override
  Future<UserModel> getUser(String email) async {
    final result = await database.query(
      userTable,
      where: 'email = ?',
      whereArgs: [email],
    );
    if (result.isNotEmpty) {
      Map<String, dynamic> json = {
        'first-name': result.first['firstname'],
        'last-name': result.first['lastname'],
        'email': result.first['email'],
      };
      return UserModel.fromJson(json);
    } else {
      throw DBException();
    }
  }

  @override
  Future<UserModel> saveUser(UserModel user) async {
    try {
      await database.insert(
        userTable,
        {
          'firstname': user.firstName,
          'lastname': user.lastName,
          'email': user.email,
        },
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
      return user;
    } catch (e) {
      throw DBException();
    }
  }
}
