import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_github_app/authentication/bloc/authentication_bloc.dart';
import 'package:my_github_app/database/authentication/users_repository.dart';
import 'package:my_github_app/home/bloc/profile_bloc.dart';
import 'package:my_github_app/home/models/profile.dart';
import 'package:my_github_app/home/view/build_full_user_data.dart';
import 'package:my_github_app/home/view/build_short_single_user.dart';
import 'package:my_github_app/login/view/login_page.dart';
import 'package:my_github_app/repository/bloc/repository_bloc.dart';
import 'package:my_github_app/repository/data_repository/data_repository.dart';
import 'package:my_github_app/repository/view/user_repos.dart';

// ignore: must_be_immutable
class GitProfileShort extends StatefulWidget {
  String user;
  GitProfileShort(String user){
    this.user=user;
  }
  @override
  _GitProfileShortState createState() => _GitProfileShortState();
}
class _GitProfileShortState extends State<GitProfileShort> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(child: Container(
        child: BlocConsumer<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfilesInitial)
              return initialProfile();
            else if (state is ProfileLoading)
              return buildLoadingState();
            else if (state is ProfileLoaded)
              return buildUser(state.profile);
            else
              return buildErrorState();
          },
          listener: (context, state) {
            if (state is  ProfileLoaded) {
              if (state.message != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Color(0xff779a76),
                  ),
                );
              }
            }
          },
        ),
      ),
    ));
  }
  Widget initialProfile() {
      submitUserName(context, widget.user);
      return buildLoadingState();
    }
  Widget buildUser(Profile profile) {
    return Column(
      children: [
        buildSingleUserData(profile),
      ],
    );
  }
  Widget buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
  Widget buildErrorState() {
    return Center(
      child: Column(children:[
        Icon(CupertinoIcons.person,size: 200,color:Color(0xff6f6f6f),),
        Text('Sorry, User has not been found!'),
      ],)
    );
  }
  void submitUserName(BuildContext context, String userName) {
    final profileBloc = context.read<ProfileBloc>();
    profileBloc.add(GetUser(userName));
    void dispose() {
      profileBloc.close();
    }
  }

}
