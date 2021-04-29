import 'dart:async';
import 'package:my_github_app/database/repository/repository_model.dart';
import 'database_repository.dart';

class RepositoryDao {
  final dbProvider = DatabaseRepositoryProvider.dbProvider;

  Future<int> createRepository(RepositoryModel user) async {
    final db = await dbProvider.database;
    var result = db.insert(repositoryTABLE, user.toDatabaseJson());
    return result;
  }

  Future<List<RepositoryModel>> getRepositories({List<String> columns, String query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (query != null) {
      if (query.isNotEmpty)
        result = await db.query(repositoryTABLE);
    } else {
      result = await db.query(repositoryTABLE, columns: columns);
    }

    List<RepositoryModel> repos = result.isNotEmpty
        ? result.map((item) => RepositoryModel.fromDatabaseJson(item)).toList()
        : [];
    return repos;
  }
  Future <List<RepositoryModel>> getUserRepositories(String owner) async {
    final db = await dbProvider.database;
    var queryResult = await db.rawQuery('SELECT * FROM Repository WHERE owner="$owner"') ;
    var res = queryResult.toList();
    if (queryResult!=null) {
      var j = 0;
      List<RepositoryModel> list = new List<RepositoryModel>(res.length);
      list.forEach((element) {
        list[j] = RepositoryModel(
            name: res[j].values.elementAt(1),
            description: res[j].values.elementAt(2),
            createdAt: res[j].values.elementAt(3),
            updatedAt: res[j].values.elementAt(4),
            language: res[j].values.elementAt(5),
            owner: res[j].values.elementAt(6),
            watchersCount: res[j].values.elementAt(7),
            defaultBranch: res[j].values.elementAt(8)
        );
      j++;});
      return list;
    }
    else return List<RepositoryModel>();
  }

  Future<RepositoryModel> getRepository(String name, owner) async {
    final db = await dbProvider.database;
    var queryResult = await db.rawQuery('SELECT * FROM Repository WHERE name="$name" AND owner="$owner"') ;
    var res = queryResult.toList();
    if (queryResult!=null){
      return RepositoryModel(
        name: res.first.values.elementAt(1),
        description: res.first.values.elementAt(2),
        createdAt: res.first.values.elementAt(3),
        updatedAt: res.first.values.elementAt(4),
        language: res.first.values.elementAt(5),
        owner: res.first.values.elementAt(6),
        watchersCount: res.first.values.elementAt(7),
        defaultBranch: res.first.values.elementAt(8)
      );
    }
    else return RepositoryModel();
  }
  Future<int> updateRepository(RepositoryModel repo) async {
    final db = await dbProvider.database;
    var queryResult = await db.rawQuery('SELECT * FROM Repository WHERE name="${repo.name}" AND owner="${repo.owner}"');
    var res = queryResult.toList();
    repo.id = res.first.values.elementAt(0);
    var result = await db.update(repositoryTABLE, repo.toDatabaseJson(),
        where: 'id = ${res.first.values.elementAt(0)}');
    print(result);
    return result;
  }

  Future<int> deleteRepo(String name) async {
    final db = await dbProvider.database;
    var result = await db.delete(repositoryTABLE, where: 'name = ?', whereArgs: [name]);

    return result;
  }
  Future<bool> checkIfExist(String name,String owner) async {
    final db = await dbProvider.database;

    var queryResult = await db.rawQuery('SELECT * FROM Repository WHERE name="$name" AND owner="$owner"');
    if (queryResult.isNotEmpty)
      return true;
    else
      return false;
  }

  Future deleteAllRepos() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      repositoryTABLE,
    );

    return result;
  }
}