import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_github_app/home/bloc/profile_bloc.dart';
import 'package:my_github_app/home/data_repository/data_repository.dart';
import 'package:my_github_app/home/models/profile.dart';
import 'package:my_github_app/home/view/profile_full.dart';
import 'package:my_github_app/home/view/text_field.dart';
import 'package:my_github_app/repository/models/model.dart';
import 'package:my_github_app/repository/view/repos_text_field.dart';


ListView buildReposData(List<Repository> repos) {
  return ListView.builder(//ListView
    shrinkWrap: true,
    itemCount: repos.length,
    itemBuilder: (BuildContext context, int index) {
      if(index==0){ // FirstElement
   return GestureDetector(
     onTap:() {/*
       Navigator.push(
         context,
         MaterialPageRoute(builder: (context) => BlocProvider(
           create: (context) => ProfileBloc(DataRepository()),
           child:GitProfile(profile[index].login),
         ),),);
     */},
     child: Column(
      children: [
      Column(
        children: [
          RepoTextField(),//Search
          if(repos.first.name !=null)
            SizedBox(height: 5),
          Row(children: [
          if(repos.first.name !=null)
          Text(
            repos.first.name,
            style: TextStyle(
              color: Color(0xff212121),
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          if(repos.first.owner !=null)
            SizedBox(height: 5),
          if(repos.first.owner !=null)
            Text(
              repos.first.owner,
              style: TextStyle(
                color: Color(0xff3e3e3e),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
          if(repos.first.description !=null)
          SizedBox(height: 10),
          if(repos.first.description !=null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:  Text(
              repos.first.description,
              style: TextStyle(
                color: Color(0xff2d2d2d),
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Color(0xff616161).withOpacity(0.2),
                blurRadius: 6,
                spreadRadius: 2,
                offset: Offset(0, 3),
              ),
            ],
            color: Color(0xffececec),
          ),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if(repos.first.updatedAt !=null)
                Column(
                  children: [
                    Text(
                      repos.first.createdAt.toString(),
                      style: TextStyle(
                        color: Color(0xff3e3e3e),
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      "Updated at",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),

                if(repos.first.language !=null)
                Column(
                  children: [
                    Text(
                      repos.first.language.toString(),
                      style: TextStyle(
                        color: Color(0xff454545),
                        fontSize: 30,
                      ),
                    ),
                    Text(
                      "Language",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),],),);
      }
      else return Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Row(children: [(repos[index].name==null? Container() :Text(repos[index].name)),
                (repos[index].owner==null
                    ?Container()
                    :RichText(text:TextSpan(text:'  ${repos[index].owner}',style: TextStyle(color:repos[index].name==null
                    ? Color(0xff212121)
                    :Color(0xff474747)),)))]),
              subtitle:repos[index].description==null? Container(padding: EdgeInsets.all(0),) : RichText(overflow: TextOverflow.ellipsis,maxLines: 2, text:TextSpan(style: TextStyle(color: Color(
                  0xff5a5a5a)),text:repos[index].description)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('Open Profile'),
                  onPressed: () {},
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