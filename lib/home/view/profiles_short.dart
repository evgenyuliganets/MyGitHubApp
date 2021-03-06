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
  refresh() {
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    waitDatabase();
    return Scaffold(
      appBar: AppBar( title:Text('Home'),backgroundColor: Color(0xff282828),
        actions: <Widget>[IconButton(
            icon: Icon(
              CupertinoIcons.person_crop_circle,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                 return waitDatabase();
                }),).then((value) => setState(() {ScaffoldMessenger.of(context).hideCurrentSnackBar();}));
            }
            ),],),

      body: Container(
            height: 650,
            child: BlocConsumer<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfilesInitial)
                  return buildInitialStart();
                else if (state is ProfilesLoading)
                  return buildLoadingState();
                else if (state is ProfilesLoaded)
                  return buildUserData(state.profile,refresh);
                else
                  return buildErrorState();
              },
              listener: (context, state) {
                if (state is ProfilesError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(duration: const Duration(seconds: 1),
                      content: Text(state.error),
                    ),
                  );
                }
                if (state is  ProfilesLoaded) {
                  if (state.message != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(duration: const Duration(seconds: 1),
                        content: Text(state.message),
                        backgroundColor: Color(0xff779a76),
                      ),
                    );
                  }
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
  Widget buildErrorState() {
    return Center(
      child: Column(
        children:[
          HomeTextField(),
          Container(height: 30,),
          Column(children:[
            Icon(Icons.signal_cellular_connected_no_internet_4_bar,
              color: Color(0xff878787),
              size: 150,),
            Container(height: 10,),
            Text('Sorry Users has not been found!',style: TextStyle(color: Color(0xff616161),fontSize: 20),)
          ])
        ],
      ),);
  }
  Widget buildInitialStart() {
    return Center(
      child: Column(
      children:[
        HomeTextField(),
        Container(height: 30,),
      Column(children:[
          Image(image:
          AssetImage('assets/logo.png'),
            color: Color(0xff878787),
            width: 150,
            height: 150,),
          Container(height: 10,),
          Text('Search your first user.',style: TextStyle(color: Color(0xff616161),fontSize: 20),)
        ])
      ],
      ),);
  }
  Widget waitDatabase() {
    return FutureBuilder(builder:(context,projectSnap) {
      if(projectSnap.connectionState==ConnectionState.done){
        return fullProfile();
      }
      else return buildLoadingState();
    },
        future: getUserFromDataBase(_userRepository));
  }

  Widget fullProfile() {
       return  BlocProvider(
            create: (context) => ProfileBloc(DataRepository()),
            child:GitProfile(user),);

  }

  Widget buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
  Future getUserFromDataBase (UsersRepository userRepository) async {
    user = await userRepository.getAllUser().then((value) =>value.first.username.toString());
  }
}
