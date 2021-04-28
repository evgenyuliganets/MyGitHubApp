import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_github_app/database/authentication/users_repository.dart';
import 'package:my_github_app/home/bloc/profile_bloc.dart';
import 'package:my_github_app/home/data_repository/data_repository.dart';
import 'package:my_github_app/home/view/profile_full.dart';
import 'package:my_github_app/home/view/text_field.dart';
import 'package:my_github_app/repository/bloc/repository_bloc.dart';
import 'package:my_github_app/repository/view/build_short_repo_data.dart';
import 'package:my_github_app/repository/view/repos_text_field.dart';


class GitReposSearch extends StatefulWidget {
  @override
  _GitReposSearchState createState() => _GitReposSearchState();
}
final _userRepository = UsersRepository();
class _GitReposSearchState extends State<GitReposSearch> {
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
        child: BlocConsumer<RepositoryBloc, RepositoryState>(
          builder: (context, state) {
            if (state is RepositoryInitial)
              return buildInitialStart();
            else if (state is RepositoriesLoading)
              return buildLoadingState();
            else if (state is RepositoriesLoaded)
              return buildReposData(state.repository);
            else
              return buildErrorState();
          },
          listener: (context, state) {
            if (state is RepositoriesError) {
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
      child: RepoTextField(),
    );
  }
  Widget buildInitialStart() {
    return Center(
      child: Column(
        children:[
          buildInitialTextField(),
          Container(height: 30,),
          Column(children:[
            Image(image:
            AssetImage('assets/logo.png'),
              color: Color(0xff878787),
              width: 150,
              height: 150,),
            Container(height: 10,),
            Text('Search your first repository.',style: TextStyle(color: Color(0xff616161),fontSize: 20),)
          ])
        ],
      ),);
  }
  Widget buildErrorState() {
    return Center(
      child: Column(
        children:[
          RepoTextField(),
          Container(height: 30,),
          Column(children:[
            Icon(Icons.signal_cellular_connected_no_internet_4_bar,
              color: Color(0xff878787),
              size: 150,),
            Container(height: 10,),
            Text('Sorry Repos has not been found!',style: TextStyle(color: Color(0xff616161),fontSize: 20),)
          ])
        ],
      ),);
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
