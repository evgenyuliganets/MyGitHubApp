import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_github_app/authentication/bloc/authentication_bloc.dart';
import 'package:my_github_app/database/authentication/users_repository.dart';
import 'package:my_github_app/home/bloc/profile_bloc.dart';
import 'package:my_github_app/home/models/profile.dart';
import 'package:my_github_app/home/view/build_full_user_data.dart';
import 'package:my_github_app/login/view/login_page.dart';

// ignore: must_be_immutable
class GitProfile extends StatefulWidget {
  String users;
  GitProfile(String users){
    this.users=users;
  }
  @override
  _GitProfileState createState() => _GitProfileState();
}
final _userRepository = UsersRepository();
class _GitProfileState extends State<GitProfile> {
  String user;
  @override
  Widget build(BuildContext context) {
    getUserFromDataBase(_userRepository);
    submitUserName(context, widget.users);
    return Scaffold(
      appBar: AppBar( title:Text('Profile'),backgroundColor: Colors.black54,
        ),

      body:  Container(
        height: 650,
        child: BlocConsumer<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading)
              return buildLoadingState();
            else if (state is ProfileLoaded)
              return buildUser(state.profile);
            else
              return buildErrorState();
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

  Widget buildUser(Profile profile) {
    return Column(
      children: [
        buildUserFullData(profile),
        if(user==widget.users)
        buildLogout(),
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
        Icon(CupertinoIcons.person,size: 200,),
        Text('Sorry, User has not been found!'),
        if(user==widget.users)
        buildLogout(),
      ],)
    );
  }
  Widget buildLogout(){
   return  RaisedButton(
      child: const Text('Logout'),
      onPressed: () {
        context
            .read<AuthenticationBloc>()
            .add(AuthenticationLogoutRequested());
        _userRepository.deleteAllUsers();
        Navigator.pushAndRemoveUntil<void>(context,
          LoginPage.route(),
              (route) => false,
        );
      },
    );
}
  void submitUserName(BuildContext context, String userName) {
    final profileBloc = context.read<ProfileBloc>();
    profileBloc.add(GetUser(userName));
    void dispose() {
      profileBloc.close();
    }
  }
  Future getUserFromDataBase (UsersRepository usersRepository) async {
    user = await usersRepository.getAllUser().then((value) =>value.first.username.toString());
  }
}
