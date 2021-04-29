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

  Future<List<ProfileModel>> getUsersProfiles({List<String> columns, String query}) async {
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
  Future<ProfileModel> getUserProfile(String login) async {
    final db = await dbProvider.database;

    var queryResult = await db.rawQuery('SELECT * FROM Profile WHERE login="$login"') ;
    var res = queryResult.toList();
    if (queryResult!=null){
      return ProfileModel(
        username: res.first.values.elementAt(1),
        login: res.first.values.elementAt(2),
        followers: res.first.values.elementAt(3),
        following: res.first.values.elementAt(4),
        publicRepos: res.first.values.elementAt(5),
        bio: res.first.values.elementAt(6),
        image: res.first.values.elementAt(7),
      );
    }
    else return ProfileModel();
  }
  Future<int> updateUserProfile(ProfileModel user) async {
    final db = await dbProvider.database;
    var queryResult = await db.rawQuery('SELECT * FROM Profile WHERE login="${user.login}"');
    var res = queryResult.toList();
    user.id = res.first.values.elementAt(0);
    var result = await db.update(profileTABLE, user.toDatabaseJson(),
        where: 'id = ${res.first.values.elementAt(0)}');
    print(result);
    return result;
  }
  Future<bool> checkIfExist(String login) async {
    final db = await dbProvider.database;

    var queryResult = await db.rawQuery('SELECT * FROM Profile WHERE login="$login"');
    if (queryResult.isNotEmpty)
      return true;
    else
      return false;
  }

  Future<int> deleteUserProfile(String login) async {
    final db = await dbProvider.database;
    var result = await db.delete(profileTABLE, where: 'login = ?', whereArgs: [login]);

    return result;
  }

  Future deleteAllUsersProfiles() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      profileTABLE,
    );

    return result;
  }
}