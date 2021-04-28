import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_github_app/authentication/bloc/authentication_bloc.dart';
import 'package:my_github_app/database/authentication/users_repository.dart';
import 'package:my_github_app/database/profile/profiles_repository.dart';
import 'package:my_github_app/home/bloc/profile_bloc.dart';
import 'package:my_github_app/home/models/profile.dart';
import 'package:my_github_app/home/view/build_full_user_data.dart';
import 'package:my_github_app/login/view/login_page.dart';
import 'package:my_github_app/repository/bloc/repository_bloc.dart';
import 'package:my_github_app/repository/data_repository/data_repository.dart';
import 'package:my_github_app/repository/view/user_repos.dart';

// ignore: must_be_immutable
class GitProfile extends StatefulWidget {
  String userMain;
  GitProfile(String userMain){
    this.userMain=userMain;
  }
  @override
  _GitProfileState createState() => _GitProfileState();
}
final _userRepository = UsersRepository();
final _profileRepository = ProfilesRepository();
class _GitProfileState extends State<GitProfile> {
  String user;
  @override
  Widget build(BuildContext context) {
    waitDatabase();
    return Scaffold(
      appBar: AppBar( title:Text('Profile'),backgroundColor: Colors.black54,
        ),
      body: SingleChildScrollView(child: Container(
        child: BlocConsumer<ProfileBloc, ProfileState>(
          // ignore: missing_return
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
            if (state is  ProfileError) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                ),
              );
            }
            if (state is  ProfileLoaded) {
              if (state.message!= null){
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );}
            }
          },
        ),
      ),
    ));
  }


  Widget initialProfile() {
      submitUserName(context, widget.userMain);
      return buildLoadingState();
    }
  Widget waitDatabase() {
    return FutureBuilder(builder:(context,projectSnap) {
      return buildLoadingState();
    },
        future: getUserFromDataBase(_userRepository));
  }
  Widget userRepos() {
    return FutureBuilder(builder:(context,projectSnap) {
      return Container(constraints: BoxConstraints(
        maxHeight: 500,),child: BlocProvider(
        create: (context) => RepositoryBloc(RepoDataRepository()),
        child:GitUserRepos(widget.userMain),));

    },
        future: getUserFromDataBase(_userRepository));
  }
  Widget buildUser(Profile profile) {
    return  Column(
      children: [
        buildUserFullData(profile),
        Column(children:[
          Text(
              'Repositories:',
              style: TextStyle(
                color: Color(0xff454545),
                fontSize: 20,)
          ),
        Container(constraints: BoxConstraints(
          maxHeight: 500,),
          child: userRepos(),),]),
        if(user==widget.userMain)
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
        Icon(CupertinoIcons.person,size: 200,color:Color(0xff6f6f6f),),
        Text('Sorry, User has not been found!'),
        if(user==widget.userMain)
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
        _profileRepository.deleteAllUsersProfile();
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
