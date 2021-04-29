import 'package:my_github_app/database/repository/repository_dao.dart';
import 'package:my_github_app/database/repository/repository_model.dart';

class RepoRepository {
  final repositoryDao = RepositoryDao();

  Future<List<RepositoryModel>> getAllRepositories({String  query}) => repositoryDao.getRepositories(query: query);

  Future<List<RepositoryModel>> getUserRepositories(String owner) => repositoryDao.getUserRepositories(owner);

  Future insertRepository(RepositoryModel repo) => repositoryDao.createRepository(repo);

  Future updateRepository(RepositoryModel repo) => repositoryDao.updateRepository(repo);

  Future deleteRepository(String name) => repositoryDao.deleteRepo(name);

  Future deleteAllRepositories() => repositoryDao.deleteAllRepos();

  Future getUserRepository(String name, String owner) => repositoryDao.getRepository(name,owner);

  Future checkIfExist(String name,String owner) => repositoryDao.checkIfExist(name,owner);
}