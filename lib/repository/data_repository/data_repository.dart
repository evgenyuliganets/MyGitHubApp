import 'dart:async';
import 'dart:io';

import 'package:github/github.dart';
import 'package:my_github_app/database/authentication/users_repository.dart';
import 'package:my_github_app/database/repository/repo_repository.dart';
import 'package:my_github_app/database/repository/repository_model.dart';
import 'package:my_github_app/repository/models/model.dart' as my;

class RepoDataRepository {
  var _repoRepository = RepoRepository();

  Future<my.Repository> fetchRepo(String name, String owner) async {
    try {
      final _userRepository = UsersRepository();
      GitHub github = GitHub(auth: Authentication.basic(
          await _userRepository.getAllUser().then((value) =>
              value.first.username.toString()),
          await _userRepository.getAllUser().then((value) =>
              value.first.password.toString())));
        Repository repository = await github.repositories.getRepository(
            RepositorySlug(owner, name));
      if (repository.owner == null) {
        throw TimeoutException("");
      } else {
        final repo = my.Repository(
          name: repository.name,
          description: repository.description,
          createdAt: repository.createdAt.toIso8601String().substring(0, 20),
          updatedAt: repository.updatedAt.toIso8601String(),
          language: repository.language,
          owner: repository.owner.login,
          defaultBranch: repository.defaultBranch,
        );
        addRepoToDatabase(repo);
        return repo;
      }
    }
    catch (Error) {
      if (Error is UnknownError|| Error is TimeoutException)
        throw MyTimeoutException();
      else if (Error is SocketException){
        throw TimeoutException("");
      }
      else throw RepoNotFoundException();
    }
  }

  addRepoToDatabase(my.Repository repo) async {
    bool ifExist;
    await _repoRepository.checkIfExist(repo.name, repo.owner).then((value) =>
    ifExist = value);
    if (ifExist == true) {
      _repoRepository.updateRepository(await parseRepoFromDatabase(repo));
    }
    else
      _repoRepository.insertRepository(await parseRepoFromDatabase(repo));
  }

  Future<RepositoryModel> parseRepoFromDatabase(my.Repository repo) async {
    return RepositoryModel(
        name: repo.name,
        description: repo.description,
        createdAt: repo.createdAt,
        updatedAt: repo.updatedAt,
        language: repo.language,
        owner: repo.owner,
        watchersCount: repo.watchersCount,
        defaultBranch: repo.defaultBranch
    );
  }

  Future<List<my.Repository>> fetchUserRepos(String userName) async {
    try {
      final _userRepository = UsersRepository();
      GitHub github = GitHub(auth: Authentication.basic(
          await _userRepository.getAllUser().then((value) =>
              value.first.username.toString()),
          await _userRepository.getAllUser().then((value) =>
              value.first.password.toString())));
        List<Repository> userRepos = await github.repositories
            .listUserRepositories(
            userName, page: 1, direction: "desc").toList();
      if (userRepos.isEmpty) {
        throw TimeoutException("");
      } else {
        if (userRepos.length > 7) {
          List<Repository> lists = new List<Repository>(7);
          lists = userRepos.toList();
          userRepos.clear();
          userRepos = [...lists];
        }
        var j = 0;
        List<my.Repository> main(List<Repository>users) {
          List<my.Repository>list = new List<my.Repository>(userRepos.length);
          list.forEach((element) {
            list[j] = my.Repository(
              name: userRepos[j].name,
              description: userRepos[j].description,
              createdAt: userRepos[j].createdAt.toIso8601String(),
              updatedAt: userRepos[j].updatedAt.toIso8601String(),
              language: userRepos[j].language,
              owner: userRepos[j].owner.login,
              defaultBranch: userRepos[j].defaultBranch,
            );
            addRepoToDatabase(list[j]);
            j++;
          });
          return list;
        }
        final List<my.Repository> repos = main(userRepos);
        return repos;
      }
    }
    catch (Error) {
      if (Error is UnknownError|| Error is TimeoutException)
        throw MyTimeoutException();
      else if (Error is SocketException){
        throw TimeoutException("");
      }
      else throw RepoNotFoundException();
    }
  }

  Future<List<my.Repository>> fetchRepos(String repoName) async {
    try {
      final _userRepository = UsersRepository();
      GitHub github = GitHub(auth: Authentication.basic(
          await _userRepository.getAllUser().then((value) =>
              value.first.username.toString()),
          await _userRepository.getAllUser().then((value) =>
              value.first.password.toString())));
      List<Repository> userRepos = await SearchService(github)
          .repositories(repoName, pages: 1).toList();
      if (userRepos.isEmpty) {
        throw TimeoutException("");
      } else {
        var j = 0;
        List<my.Repository> main(List<Repository>users) {
          List<my.Repository>list = new List<my.Repository>(users.length);
          list.forEach((element) {
            list[j] = my.Repository(
              name: userRepos[j].name,
              description: userRepos[j].description,
              createdAt: userRepos[j].createdAt.toIso8601String().substring(
                  1, 19),
              updatedAt: userRepos[j].updatedAt.toIso8601String().substring(
                  1, 19),
              language: userRepos[j].language,
              owner: userRepos[j].owner.login,
              defaultBranch: userRepos[j].defaultBranch,
            );
            j++;
          });
          return list;
        }
        final List<my.Repository> repos = main(userRepos);
        return repos;
      }
    }
    catch (Error) {
      if (Error is UnknownError|| Error is TimeoutException)
        throw MyTimeoutException();
      else if (Error is SocketException){
        throw TimeoutException("");
      }
      else throw RepoNotFoundException();
    }
  }

  Future<my.Repository> fetchRepoFromDataBase(String name, String owner) async {
    try {
      final _repoRepository = RepoRepository();
      RepositoryModel repoDatabase = await _repoRepository.getUserRepository(
          name, owner);
      if (repoDatabase == null) {
        throw RepoNotFoundException();
      } else {
        final repo = my.Repository(
            name: repoDatabase.name,
            description: repoDatabase.description,
            createdAt: repoDatabase.createdAt,
            updatedAt: repoDatabase.updatedAt,
            language: repoDatabase.language,
            owner: repoDatabase.owner,
            watchersCount: repoDatabase.watchersCount,
            defaultBranch: repoDatabase.defaultBranch
        );
        return repo;
      }
    }
    catch (Error) {
      throw RepoNotFoundException();
    }
  }

  Future <List<my.Repository>> fetchUserReposFromDataBase(String owner) async {
    try {
      final _repoRepository = RepoRepository();
      List<RepositoryModel> repoDatabase = await _repoRepository
          .getUserRepositories(owner);
      if (repoDatabase.isEmpty) {
        throw RepoNotFoundException();
      } else {
        var j = 0;
        List<my.Repository> list= new List<my.Repository>(repoDatabase.length);
        list.forEach((element) {
          list[j]= my.Repository(
              name: repoDatabase[j].name,
              description: repoDatabase[j].description,
              createdAt: repoDatabase[j].createdAt,
              updatedAt: repoDatabase[j].updatedAt,
              language: repoDatabase[j].language,
              owner: repoDatabase[j].owner,
              watchersCount: repoDatabase[j].watchersCount,
              defaultBranch: repoDatabase[j].defaultBranch
          );
          j++;
        });
        return list;
      }
    }

    catch (Error) {
      throw RepoNotFoundException();
    }
  }

  Future <List<my.Repository>> fetchReposFromDataBase() async {
    try {
      final _repoRepository = RepoRepository();
      List<RepositoryModel> repoDatabase = await _repoRepository
          .getAllRepositories();
      if (repoDatabase.isEmpty) {
        throw RepoNotFoundException();
      } else {
        var j = 0;
        List<my.Repository> list= new List<my.Repository>(repoDatabase.length);
        list.forEach((element) {
          list[j]= my.Repository(
              name: repoDatabase[j].name,
              description: repoDatabase[j].description,
              createdAt: repoDatabase[j].createdAt,
              updatedAt: repoDatabase[j].updatedAt,
              language: repoDatabase[j].language,
              owner: repoDatabase[j].owner,
              watchersCount: repoDatabase[j].watchersCount,
              defaultBranch: repoDatabase[j].defaultBranch
          );
          j++;
        });
        return list;
      }
    }

    catch (Error) {
      throw RepoNotFoundException();
    }
  }
}

class MyTimeoutException implements Exception{}

class RepoNotFoundException implements Exception {}