import 'dart:async';
import 'package:my_github_app/database/database.dart';
import 'package:my_github_app/database/model.dart';

class ProfileDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> createTodo(UserModel user) async {
    final db = await dbProvider.database;
    var result = db.insert(userTABLE, user.toDatabaseJson());
    return result;
  }

  Future<List<UserModel>> getUsers({List<String> columns, String query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (query != null) {
      if (query.isNotEmpty)
        result = await db.query(userTABLE);
    } else {
      result = await db.query(userTABLE, columns: columns);
    }

    List<UserModel> users = result.isNotEmpty
        ? result.map((item) => UserModel.fromDatabaseJson(item)).toList()
        : [];
    return users;
  }

  Future<int> updateUser(UserModel user) async {
    final db = await dbProvider.database;

    var result = await db.update(userTABLE, user.toDatabaseJson(),
        where: "id = ?", whereArgs: [user.id]);

    return result;
  }

  Future<int> deleteUser(int id) async {
    final db = await dbProvider.database;
    var result = await db.delete(userTABLE, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  //We are not going to use this in the demo
  Future deleteAllUsers() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      userTABLE,
    );

    return result;
  }
}