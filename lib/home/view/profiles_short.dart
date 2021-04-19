import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_github_app/database/authentication/users_repository.dart';
import 'package:my_github_app/home/bloc/profile_bloc.dart';
import 'package:my_github_app/home/data_repository/data_repository.dart';
import 'package:my_github_app/home/view/profile_full.dart';
import 'package:my_github_app/home/view/text_field.dart';

import 'build_short_user_data.dart';

class GitProfiles extends StatefulWidget {
  @override
  _GitProfilesState createState() => _GitProfilesState();
}
final _userRepository = UsersRepository();
class _GitProfilesState extends State<GitProfiles> {
  String user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title:Text('Home'),backgroundColor: Colors.black54,
        actions: <Widget>[IconButton(
            icon: Icon(
              CupertinoIcons.person_crop_circle,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                 return projectWidget();
                }),);
            }
            ),],),

      body: Container(
            height: 650,
            child: BlocConsumer<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfilesInitial)
                  return buildInitialTextField();
                else if (state is ProfilesLoading)
                  return buildLoadingState();
                else if (state is ProfilesLoaded)
                  return buildUserData(state.profile);
                else
                  return buildInitialTextField();
              },
              listener: (context, state) {
                if (state is ProfileError) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                    ),
                  );
                }
              },
            ),
          ),
    );
  }
  Widget buildInitialTextField() {
    return Center(
      child: HomeTextField(),
    );
  }

  Widget projectWidget() {
    return FutureBuilder(builder:(context,projectSnap) {
       return  BlocProvider(
            create: (context) => ProfileBloc(DataRepository()),
            child:GitProfile(user),);

    },
    future: getUserFromDataBase(_userRepository));
  }

  Widget buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
  Future getUserFromDataBase (_userRepository) async {
    user = await _userRepository.getAllUser().then((value) =>value.first.username.toString());
  }
}
