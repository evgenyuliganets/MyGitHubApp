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
              return buildInitialTextField();
            else if (state is RepositoriesLoading)
              return buildLoadingState();
            else if (state is RepositoriesLoaded)
              return buildReposData(state.repository);
            else
              return buildInitialTextField();
          },
          listener: (context, state) {
            if (state is RepositoryError) {
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
