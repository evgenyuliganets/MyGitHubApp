import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:github/github.dart';
import 'package:my_github_app/database/authentication/users_repository.dart';
import 'package:my_github_app/database/profile/profiles_model.dart';
import 'package:my_github_app/database/profile/profiles_repository.dart';
import 'package:my_github_app/home/models/profile.dart';
class DataRepository {
  final _profileRepository= ProfilesRepository();

  Future<Profile> fetchUser(String userName) async {
    try{
      final _userRepository = UsersRepository();
    GitHub github= GitHub(auth: Authentication.basic(await _userRepository.getAllUser().then((value) =>
        value.first.username.toString()), await _userRepository.getAllUser().then((value) =>
        value.first.password.toString())));
        User user =await github.users.getUser(userName);
      if (user.login==null) {
        throw TimeoutException('');
      } else {
        final profile = Profile(
          login: user.login,
          name: user.name,
          bio: user.bio,
          followers: user.followersCount,
          following: user.followingCount,
          image: Image.network(user.avatarUrl).image,
          publicRepos: user.publicReposCount,
        );
        await addProfileToDatabase(profile,user.avatarUrl);
        return profile;
      }
    }
    catch (Error) {
      if (Error is UnknownError||Error is TimeoutException)
        throw MyTimeoutException();
      else if (Error is SocketException){
        throw TimeoutException("");
      }
      else throw UserNotFoundException();
    }
  }
  addProfileToDatabase(Profile profile, String url) async {
    bool ifExist;
    await _profileRepository.checkIfExist(profile.login).then((value) => ifExist= value);
    if (ifExist==true) {
      _profileRepository.updateUserProfile(await parseProfileFromDatabase(profile,url));
    }
    else
      _profileRepository.insertUserProfile(await parseProfileFromDatabase(profile,url));
  }

  Future<ProfileModel> parseProfileFromDatabase(Profile profile, String url) async {
    var response=await NetworkAssetBundle(Uri.parse("")).load(url);
    return ProfileModel(
        username: profile.name,
        login: profile.login,
        followers: profile.followers,
        following: profile.following,
        bio: profile.bio,
        image: response.buffer.asUint8List(),
        publicRepos: profile.publicRepos,
    );
  }
  Future<Profile> fetchUserFromDataBase(String userName) async {
    try{
      final _profileRepository= ProfilesRepository();
      ProfileModel profileDatabase=  await _profileRepository.getUserProfile(userName);
      if (profileDatabase==null) {
        throw UserNotFoundException();
      } else {
        final profile = Profile(
          name: profileDatabase.username,
          login: profileDatabase.login,
          bio: profileDatabase.bio,
          followers: profileDatabase.followers,
          following: profileDatabase.following,
          image: Image.memory(profileDatabase.image).image,
          publicRepos: profileDatabase.publicRepos,
        );
        return profile;
      }
    }
    catch (Error) {
      throw UserNotFoundException();
    }
  }
  Future <List<Profile>> fetchUsersFromDataBase(String userName) async {
    try {
      final _profileRepository = ProfilesRepository();
      List<ProfileModel> profileDatabase = await _profileRepository
          .getAllUserProfile();
      if (profileDatabase.isEmpty) {
        throw UserNotFoundException();
      } else {
        var j = 0;
        List<Profile> list= new List<Profile>(profileDatabase.length);
        list.forEach((element) {
          list[j]= Profile(
            name: profileDatabase[j].username,
            login: profileDatabase[j].login,
            bio: profileDatabase[j].bio,
            followers: profileDatabase[j].followers,
            following: profileDatabase[j].following,
            image: Image.memory(profileDatabase[j].image).image,
            publicRepos: profileDatabase[j].publicRepos,
          );
          j++;
        });
        return list;
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
      if (search.isEmpty) {
        throw TimeoutException("");
      } else {
        List<String> names= new List<String>(search.length);var i=0;
        search.forEach((element){
          names[i]= element.login;
          i++;});
        List<User> user = await github.users.getUsers(names).toList();var j=0;
        Future<List<Profile>> main(List<User>users) async {List<Profile>list= new List<Profile>(users.length);
        await Future.forEach(list,(element) async {
          list[j]=Profile(
          login: users[j].login,
          name: users[j].name,
          bio: users[j].bio,
          followers: users[j].followersCount,
          following: users[j].followingCount,
          image: Image.network(users[j].avatarUrl).image,
          publicRepos: users[j].publicReposCount,
        );j++;}); return list;}
        final List<Profile> profile=await main(user);
        return profile;
      }
    }
    catch(Error) {
      if (Error is UnknownError|| Error is TimeoutException)
        throw MyTimeoutException();
      else if (Error is SocketException ){
        throw TimeoutException("");
      }
      else throw UserNotFoundException();
    }
  }
}


class UserNotFoundException implements Exception {}
class MyTimeoutException implements Exception {}