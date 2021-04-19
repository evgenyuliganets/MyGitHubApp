
import 'package:github/github.dart';
import 'package:my_github_app/database/authentication/users_repository.dart';
import 'package:my_github_app/home/models/profile.dart';
class DataRepository {
  Future<Profile> fetchUser(String userName) async {
    try{
      final _userRepository = UsersRepository();
    GitHub github= GitHub(auth: Authentication.basic(await _userRepository.getAllUser().then((value) =>
        value.first.username.toString()), await _userRepository.getAllUser().then((value) =>
        value.first.password.toString())));
      if (github ==null) {
        throw UserNotFoundException();
      } else {
        User user =await github.users.getUser(userName);
        final profile = Profile(
          login: user.login,
          name: user.name,
          bio: user.bio,
          followers: user.followersCount,
          following: user.followingCount,
          image: user.avatarUrl,
          publicRepos: user.publicReposCount,
        );
        return profile;
      }
    }
    catch (Error) {
      throw UserNotFoundException();
    }
  }
  Future<List<Profile>> fetchUsers(String userName) async {
    try {
      final _userRepository = UsersRepository();
      GitHub github = GitHub(auth: Authentication.basic(
          await _userRepository.getAllUser().then((value) =>
              value.first.username.toString()),
          await _userRepository.getAllUser().then((value) =>
              value.first.password.toString())));
      List<User> search = await SearchService(github)
          .users(userName,pages: 1,perPage: 5).toList();
      if (search == null) {
        throw UserNotFoundException();
      } else {
        List<String> names= new List<String>(search.length);var i=0;
        search.forEach((element){
          names[i]= element.login;
          i++;});
        List<User> user = await github.users.getUsers(names).toList();var j=0;
        List<Profile> main(List<User>users) {List<Profile>list= new List<Profile>(users.length);
        list.forEach((element) {list[j]=Profile(
          login: users[j].login,
          name: users[j].name,
          bio: users[j].bio,
          followers: users[j].followersCount,
          following: users[j].followingCount,
          image: users[j].avatarUrl,
          publicRepos: users[j].publicReposCount,
        );j++;}); return list;}
        final List<Profile> profile=main(user);
        return profile;
      }
    }
    catch (Error) {
      throw UserNotFoundException();
    }
  }
}


class UserNotFoundException implements Exception {}
