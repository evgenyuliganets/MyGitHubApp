import 'dart:typed_data';

class ProfileModel {
  int id;
  String username;
  String login;
  int followers;
  int following;
  int publicRepos;
  String bio;
  Uint8List image;
  ProfileModel({this.id, this.username, this.login,this.followers,this.bio,this.image,this.following,this.publicRepos});
  factory ProfileModel.fromDatabaseJson(Map<String, dynamic> data) => ProfileModel(
    id: data['id'],
    username: data['username'],
    login: data['password'] ,
    followers: data['followers'],
    following: data['following'],
    publicRepos: data['publicRepos'],
    bio: data['bio'],
    image: data['image'] ,
  );
  Map<String, dynamic> toDatabaseJson() => {
    "id": this.id,
    "username": this.username,
    "login": this.login ,
    "followers": this.followers ,
    "following": this.following ,
    "publicRepos": this.publicRepos ,
    "bio": this.bio ,
    "image": this.image ,
  };
}