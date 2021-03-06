

import 'package:flutter/material.dart';

class Profile {
  final String name;
  final String login;
  final int followers;
  final int following;
  final int publicRepos;
  final String bio;
  final ImageProvider image;

  Profile({
    this.name,
    this.login,
    this.followers,
    this.following,
    this.publicRepos,
    this.bio,
    this.image,
  });
}
