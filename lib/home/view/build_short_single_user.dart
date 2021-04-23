import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_github_app/home/bloc/profile_bloc.dart';
import 'package:my_github_app/home/data_repository/data_repository.dart';
import 'package:my_github_app/home/models/profile.dart';
import 'package:my_github_app/home/view/profile_full.dart';


Builder buildSingleUserData(Profile profile) {
  return Builder(builder:(context) =>Card(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Image(image: NetworkImage(profile.image),),
                title: Row(children: [(profile.name==null? Container() :Text(profile.name)),
                  (profile.login==null
                      ?Container()
                      :RichText(text:TextSpan(text:'  ${profile.login}',style: TextStyle(color:profile.name==null
                      ? Color(0xff212121)
                      :Color(0xff474747)),)))]),
                subtitle:profile.bio==null? Container(padding: EdgeInsets.all(0),) : RichText(overflow: TextOverflow.ellipsis,maxLines: 2, text:TextSpan(style: TextStyle(color: Color(
                    0xff5a5a5a)),text:profile.bio)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: const Text('Open Profile'),
                    onPressed: () {Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BlocProvider(
                        create: (context) => ProfileBloc(DataRepository()),
                        child:GitProfile(profile.login),
                      ),),);},
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ]
        ),
      )
  );
}