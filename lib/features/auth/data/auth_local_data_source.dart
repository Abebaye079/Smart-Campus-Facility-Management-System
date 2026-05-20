import 'package:sqflite/sqflite.dart';
import 'package:smart_campus_app/core/database/db_helper.dart';
import 'package:smart_campus_app/features/auth/domain/models/user_model.dart';

class AuthLocalDataSource {
  Future<void> saveUser(UserModel user) async {
    final Database db = await DBHelper.database;

    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserModel?> getUser() async {
    final Database db = await DBHelper.database;

    final maps = await db.query('users', limit: 1);

    if (maps.isEmpty) return null;

    return UserModel.fromMap(maps.first);
  }

  Future<void> clearUser() async {
    final Database db = await DBHelper.database;

    await db.delete('users');
  }
}