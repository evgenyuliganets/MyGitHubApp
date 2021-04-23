import 'package:github/github.dart';
import 'package:my_github_app/database/authentication/users_repository.dart';
import 'package:my_github_app/repository/models/model.dart' as my;

class RepoDataRepository {
  Future<my.Repository> fetchRepo(String name,String owner) async {
    try{
      final _userRepository = UsersRepository();
      GitHub github= GitHub(auth: Authentication.basic(await _userRepository.getAllUser().then((value) =>
          value.first.username.toString()), await _userRepository.getAllUser().then((value) =>
          value.first.password.toString())));
      if (github ==null) {
        throw RepoNotFoundException();
      } else {
        Repository repository =await github.repositories.getRepository(RepositorySlug(owner,name));
        final repo = my.Repository(
          name: repository.name,
          description: repository.description,
          createdAt: repository.createdAt.toIso8601String().substring(0,20),
          updatedAt: repository.updatedAt.toIso8601String(),
          language: repository.language,
          owner: repository.owner.login,
          defaultBranch: repository.defaultBranch,
          image: repository.owner.avatarUrl,
        );
        return repo;
      }
    }
    catch (Error) {
      throw RepoNotFoundException();
    }
  }
  Future<List<my.Repository>> fetchUserRepos(String userName) async {
    try{
      final _userRepository = UsersRepository();
      GitHub github= GitHub(auth: Authentication.basic(await _userRepository.getAllUser().then((value) =>
          value.first.username.toString()), await _userRepository.getAllUser().then((value) =>
          value.first.password.toString())));
      if (github ==null) {
        throw RepoNotFoundException();
      } else {
        List<Repository> userRepos = await github.repositories.listUserRepositories(userName,sort: 'created').toList();
        if(userRepos.length>7){
          List<Repository> lists = new List<Repository>(7);
          lists= userRepos.getRange(userRepos.length-7, userRepos.length).toList();
          userRepos.clear();
          userRepos=[...lists];
        }
        var j=0;
        List<my.Repository> main(List<Repository>users) {List<my.Repository>list= new List<my.Repository>(userRepos.length);
        list.forEach((element) {list[j]=my.Repository(
          name: userRepos[j].name,
          description: userRepos[j].description,
          createdAt: userRepos[j].createdAt.toIso8601String(),
          updatedAt: userRepos[j].updatedAt.toIso8601String(),
          language: userRepos[j].language,
          owner: userRepos[j].owner.login,
          defaultBranch: userRepos[j].defaultBranch,
          image: userRepos[j].owner.avatarUrl,
        );j++;}); return list;}
        final List<my.Repository> repos=main(userRepos);
        return repos;
      }
    }
    catch (Error) {
      throw RepoNotFoundException();
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
          .repositories(repoName,pages:1).toList();
      if (userRepos == null) {
        throw RepoNotFoundException();
      } else {
        var j=0;
        List<my.Repository> main(List<Repository>users) {List<my.Repository>list= new List<my.Repository>(users.length);
        list.forEach((element) {
          list[j]=my.Repository(
          name: userRepos[j].name,
          description: userRepos[j].description,
          createdAt: userRepos[j].createdAt.toIso8601String().substring(1,19),
          updatedAt: userRepos[j].updatedAt.toIso8601String().substring(1,19),
          language: userRepos[j].language,
          owner: userRepos[j].owner.login,
          defaultBranch: userRepos[j].defaultBranch,
          image: userRepos[j].owner.avatarUrl,
        );j++;}); return list;}
        final List<my.Repository> repos=main(userRepos);
        return repos;
      }
    }
    catch (Error) {
      throw RepoNotFoundException();
    }
  }
}
class RepoNotFoundException implements Exception {}