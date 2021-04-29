import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_github_app/database/authentication/users_repository.dart';
import 'package:my_github_app/home/bloc/profile_bloc.dart';
import 'package:my_github_app/home/data_repository/data_repository.dart';
import 'package:my_github_app/home/view/profile_full.dart';
import 'package:my_github_app/repository/bloc/repository_bloc.dart';
import 'package:my_github_app/repository/view/build_short_repo_data.dart';
import 'package:my_github_app/repository/view/build_user_repos.dart';
import 'package:my_github_app/repository/view/repos_text_field.dart';


// ignore: must_be_immutable
class GitUserRepos extends StatefulWidget {
  String users;
  GitUserRepos(String users){
    this.users=users;
  }
  @override
  _GitUserReposState createState() => _GitUserReposState();
}
final _userRepository = UsersRepository();
class _GitUserReposState extends State<GitUserRepos> {
  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<RepositoryBloc, RepositoryState>(
            builder: (context, state) {
              if (state is RepositoryInitial)
                return initialRepos();
              else if (state is UserRepositoriesLoading)
                return buildLoadingState();
              else if (state is UserRepositoriesLoaded)
                return buildUserReposData(state.repository);
              else
                return buildErrorState();
            },
            listener: (context, state) {
              if (state is UserRepositoriesError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(duration: const Duration(seconds: 1),
                    content: Text(state.error),
                  ),
                );
              }
              if (state is  UserRepositoriesLoaded) {
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

          );

  }
  Widget buildErrorState() {
    return Center(
        child: Column(children:[
          Icon(CupertinoIcons.folder,size: 200,color: Color(0xff6f6f6f),),
          Text('Sorry, Repositories has not been found!'),
        ],)
    );
  }
  Widget initialRepos() {
    submitUserName(context, widget.users);
    return buildLoadingState();
  }

  Widget buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  void submitUserName(BuildContext context, String userName) {
    final repoBloc = context.read<RepositoryBloc>();
    repoBloc.add(GetUserRepos(userName));
    void dispose() {
      repoBloc.close();
    }
  }
}
