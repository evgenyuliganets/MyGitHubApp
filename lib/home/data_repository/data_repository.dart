
import 'package:github/github.dart';
import 'package:my_github_app/database/users_repository.dart';
import 'package:my_github_app/home/models/profile.dart';
class DataRepository {
  Future<Profile> fetchUser(String userName) async {
    try{
      final _userRepository = UsersRepository();
    GitHub github= GitHub(auth: Authentication.basic(await _userRepository.getAllUser().then((value) =>
        value.first.username.toString()), await _userRepository.getAllUser().then((value) =>
        value.first.password.toString())));
    User search= await SearchService(github).users(userName).first;
      if (search ==null) {
        throw UserNotFoundException();
      } else {
        var user =await github.users.getUser(search.login);
        final profile = Profile(
          name: search.login,
          bio: user.bio,
          followers: user.followersCount,
          following: user.followingCount,
          image: user.avatarUrl,
          public_repos: user.publicReposCount,
        );
        return profile;
      }
    }
    catch (Error) {
      throw UserNotFoundException();
    }
  }
}

class UserNotFoundException implements Exception {}
