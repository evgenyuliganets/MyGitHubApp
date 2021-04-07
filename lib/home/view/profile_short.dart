import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_github_app/home/bloc/profile_bloc.dart';
import 'package:my_github_app/home/view/text_field.dart';

import 'build_short_user_data.dart';

class GitProfile extends StatefulWidget {
  @override
  _GitProfileState createState() => _GitProfileState();
}
var toggle= false;
class _GitProfileState extends State<GitProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: const Text('Home'),backgroundColor: Colors.black54,
        actions: <Widget>[IconButton(
            icon: toggle
                ? Icon(Icons.login)
                : Icon(
              CupertinoIcons.person_crop_circle,
            ),
            onPressed: () {
              setState(() {
                toggle = !toggle;
              });
            }),],),

      body: ListView(
        children: [
          Container(
            height: 650,
            child: BlocConsumer<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileInitial)
                  return buildInitialTextField();
                else if (state is ProfileLoading)
                  return buildLoadingState();
                else if (state is ProfileLoaded)
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
        ],
      ),
    );
  }
  Widget buildInitialTextField() {
    return Center(
      child: HomeTextField(),
    );
  }

  Widget buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
