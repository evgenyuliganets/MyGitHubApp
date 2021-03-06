import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_github_app/home/bloc/profile_bloc.dart';
import 'package:my_github_app/repository/bloc/repository_bloc.dart';
import 'package:my_github_app/repository/data_repository/data_repository.dart';
import 'package:my_github_app/repository/view/repositorys_search.dart';

class HomeTextField extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  Widget build(BuildContext context) {
    return Column(children: [
      Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              child: TextField(
                onSubmitted: (value) =>
                    submitUserName(context, _controller.text),
                controller: _controller,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  hintText: 'Search User Here',
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
          ),
        ),
      ],
      ),
       Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children:[
            Padding(padding: const EdgeInsets.all(0),
                child: OutlineButton( onPressed:() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BlocProvider(
                      create: (context) => RepositoryBloc(RepoDataRepository()),
                      child:GitReposSearch(),
                    ),),);
                  },
                  child: Text('Search Repositories'),
                )
            )
          ]),
    ]);
  }

  void submitUserName(BuildContext context, String userName) {
    final profileBloc = context.read<ProfileBloc>();
    profileBloc.add(GetUsers(userName));
    void dispose() {
      profileBloc.close();
    }
  }

}
