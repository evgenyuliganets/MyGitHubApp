import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_github_app/home/bloc/profile_bloc.dart';
import 'package:my_github_app/home/data_repository/data_repository.dart';
import 'package:my_github_app/repository/bloc/repository_bloc.dart';
import 'package:my_github_app/repository/data_repository/data_repository.dart';
import 'package:my_github_app/repository/models/model.dart';
import 'package:my_github_app/repository/view/single_repository.dart';


ListView buildUserReposData(List<Repository> repos) {
  return ListView.builder(//ListView
    shrinkWrap: true,
    itemCount: repos.length,
    itemBuilder: (BuildContext context, int index) {
       return Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading:repos[index].language==null? new Column (crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Unknown',style: TextStyle(
                color: Color(0xff454545),
                fontSize: 20,
              ),),Text('Language',style: TextStyle(
                color: Color(0xff454545),
                fontSize: 20,
              ),)],) : Column (crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center, children: [Text(
                repos[index].language.toString(),
                style: TextStyle(
                  color: Color(0xff454545),
                  fontSize: 20,
                ),
              ),],),
              title: Center(child:Column( children: [(repos[index].name==null? Container() :Text(repos[index].name,style: TextStyle(
                fontSize: 20,
              ) )),
                ]),),
              subtitle:Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                (repos[index].owner==null
                    ?Container()
                    :RichText(text:TextSpan(text:'Owner: ' +repos[index].owner,style: TextStyle(color:Color(0xff474747)),))),
                repos[index].description==null? Container() : RichText(overflow: TextOverflow.ellipsis,maxLines: 2, text:TextSpan(style: TextStyle(color: Color(
                    0xff5a5a5a)),text:'Description: '+repos[index].description)),
              ]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('Open Repository'),
                  onPressed: () {Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BlocProvider(
                      create: (context) => RepositoryBloc(RepoDataRepository()),
                      child:SingleRepo(repos[index].owner,repos[index].name),
                    ),),);},
                ),
                const SizedBox(width: 8),
              ],
            ),
          ]
        ),
      );
      },
      );
}