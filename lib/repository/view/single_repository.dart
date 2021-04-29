import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_github_app/home/bloc/profile_bloc.dart';
import 'package:my_github_app/home/data_repository/data_repository.dart';
import 'package:my_github_app/home/view/profile_single_short.dart';
import 'package:my_github_app/repository/bloc/repository_bloc.dart';
import 'package:my_github_app/repository/models/model.dart';
import 'build_single_repo.dart';


// ignore: must_be_immutable
class SingleRepo extends StatefulWidget {
  String user;
  String repoName;
  SingleRepo(String user,String repoName){
    this.user=user;
    this.repoName=repoName;
  }
  @override
  _SingleRepoState createState() => _SingleRepoState();
}
class _SingleRepoState extends State<SingleRepo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar( title:Text('Repository'),backgroundColor: Colors.black54,
        ),
        body:  Container(
            child: BlocConsumer<RepositoryBloc, RepositoryState>(
              builder: (context, state) {
                if (state is RepositoryInitial)
                  return initialRepo();
                else if (state is RepositoryLoading)
                  return buildLoadingState();
                else if (state is RepositoryLoaded)
                  return buildRepo(state.repository);
                else
                  return buildErrorState();
              },
              listener: (context, state) {
                if (state is RepositoryError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(duration: const Duration(seconds: 1),
                      content: Text(state.error),
                    ),
                  );
                }
                if (state is RepositoryLoaded) {
                  if (state.message!=null)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(duration: const Duration(seconds: 1),
                        content: Text(state.message),
                        backgroundColor: Color(0xff779a76),
                      ),
                    );
                }
              },
            )));
  }
  Widget buildErrorState() {
    return Center(
        child: Column(children:[
          Icon(CupertinoIcons.folder,size: 200,color: Color(0xff6f6f6f),),
          Text('Sorry, Repository has not been found!'),
        ],)
    );
  }
  Widget initialRepo() {
    submitUserName(context, widget.user,widget.repoName);
    return buildLoadingState();
  }

  Widget buildRepo(Repository repository) {
    return Column(
      children: [
        buildSingleRepoData(repository),
        Column(children:[
          Text(
              'Owner:',
              style: TextStyle(
                color: Color(0xff454545),
                fontSize: 20,)
          ),
          Container(height: 200,child: ownerShort(),),]),
      ],
    );
  }
  Widget ownerShort() {
    return FutureBuilder(builder:(context,projectSnap) {
      return  BlocProvider(
        create: (context) => ProfileBloc(DataRepository()),
        child:GitProfileShort(widget.user),);

    });
  }
  Widget buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }


  void submitUserName(BuildContext context, String userName,String repoName) {
    final repoBloc = context.read<RepositoryBloc>();
    repoBloc.add(GetRepo(repoName,userName));
    void dispose() {
      repoBloc.close();
    }
  }
}
