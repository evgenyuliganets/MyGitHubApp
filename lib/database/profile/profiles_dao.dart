import 'dart:async';
import 'package:my_github_app/database/profile/profiles_model.dart';
import 'database_profile.dart';

class ProfileDao {
  final dbProvider = DatabaseProfileProvider.dbProvider;

  Future<int> createProfile(ProfileModel user) async {
    final db = await dbProvider.database;
    var result = db.insert(profileTABLE, user.toDatabaseJson());
    return result;
  }

  Future<List<ProfileModel>> getUsers({List<String> columns, String query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (query != null) {
      if (query.isNotEmpty)
        result = await db.query(profileTABLE);
    } else {
      result = await db.query(profileTABLE, columns: columns);
    }

    List<ProfileModel> users = result.isNotEmpty
        ? result.map((item) => ProfileModel.fromDatabaseJson(item)).toList()
        : [];
    return users;
  }

  Future<int> updateUser(ProfileModel user) async {
    final db = await dbProvider.database;

    var result = await db.update(profileTABLE, user.toDatabaseJson(),
        where: "id = ?", whereArgs: [user.id]);

    return result;
  }

  Future<int> deleteUser(int id) async {
    final db = await dbProvider.database;
    var result = await db.delete(profileTABLE, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  Future deleteAllUsers() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      profileTABLE,
    );

    return result;
  }
}