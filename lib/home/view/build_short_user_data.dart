import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_github_app/database/profile/profiles_repository.dart';
import 'package:my_github_app/home/bloc/profile_bloc.dart';
import 'package:my_github_app/home/data_repository/data_repository.dart';
import 'package:my_github_app/home/models/profile.dart';
import 'package:my_github_app/home/view/profile_full.dart';
import 'package:my_github_app/home/view/profiles_short.dart';
import 'package:my_github_app/home/view/text_field.dart';


ListView buildUserData(List<Profile> profile,Function() notifyParent) {
  var profileRepository= ProfilesRepository();
  GitProfiles gitProfiles= new GitProfiles();
  bool val;
  return ListView.builder(//ListView
    shrinkWrap: true,
    itemCount: profile.length,
    itemBuilder:(BuildContext context, int index) {
        if(index==0){ // FirstElement
          return GestureDetector(
            onTap:() {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BlocProvider(
                  create: (context) => ProfileBloc(DataRepository()),
                  child:GitProfile(profile[index].login),
                ),),).then((value) => gitProfiles.createState().refresh());
            },
            child: Column(
              children: [
                Column(
                  children: [
                    HomeTextField(),//Search
                    if (profile[index].image != null)
                      Container(
                        width: 150,
                        height: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image(image:profile[index].image),
                        ),
                      ),
                    if(profile.first.name !=null)
                      SizedBox(height: 5),
                    if(profile.first.name !=null)
                      Text(
                        profile.first.name,
                        style: TextStyle(
                          color: Color(0xff212121),
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children:[
                    SizedBox(height: 5),
                    Text(
                      profile.first.login,
                      style: TextStyle(
                        color: Color(0xff3e3e3e),
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                      FutureBuilder(
                          future: profileRepository.checkIfExist(profile[index].login).then((value) => val= value),
                          builder: (context,waiter) {
                            return Container(height: 30, width: 30, child:
                            waiter.hasData==true
                                ? val == false ? Container() :Icon(Icons.save, size: 30, color: Colors.green,)
                                :CircularProgressIndicator()
                            );
                          }),
                    ]),
                    if(profile.first.bio !=null)
                      SizedBox(height: 10),
                    if(profile.first.bio !=null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:  Text(
                          profile.first.bio,
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
                          if(profile.first.followers !=null)
                            Column(
                              children: [
                                Text(
                                  profile.first.followers.toString(),
                                  style: TextStyle(
                                    color: Color(0xff3e3e3e),
                                    fontSize: 30,
                                  ),
                                ),
                                Text(
                                  "Followers",
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          if(profile.first.following !=null)
                            Column(
                              children: [
                                Text(
                                  profile.first.following.toString(),
                                  style: TextStyle(
                                    color: Color(0xff404040),
                                    fontSize: 30,
                                  ),
                                ),
                                Text(
                                  "Following",
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          if(profile.first.publicRepos !=null)
                            Column(
                              children: [
                                Text(
                                  profile.first.publicRepos.toString(),
                                  style: TextStyle(
                                    color: Color(0xff454545),
                                    fontSize: 30,
                                  ),
                                ),
                                Text(
                                  "Repositories",
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
        else
          return Card(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading:Image(image:profile[index].image),
                  title: profile[index].name==null? (profile[index].login==null
                      ?Container()
                      :RichText(text:TextSpan(text:'  ${profile[index].login}',style: TextStyle(color:profile[index].name==null
                      ? Color(0xff212121)
                      :Color(0xff474747)),))): profile[index].name.length <= 10
                      ?Row(children: [(profile[index].name==null? Container() :Text(profile[index].name)),
                    (profile[index].login==null
                        ?Container()
                        :RichText(text:TextSpan(text:'  ${profile[index].login}',style: TextStyle(color:profile[index].name==null
                        ? Color(0xff212121)
                        :Color(0xff474747)),)))])
                      : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [(profile[index].name==null? Container() :Text(profile[index].name)),
                    (profile[index].login==null
                        ?Container()
                        :RichText(text:TextSpan(text:'${profile[index].login}',style: TextStyle(color:profile[index].name==null
                        ? Color(0xff212121)
                        :Color(0xff474747)),)))]),
                  subtitle:profile[index].bio==null? Container(padding: EdgeInsets.all(0),) : RichText(overflow: TextOverflow.ellipsis,maxLines: 2, text:TextSpan(style: TextStyle(color: Color(
                      0xff5a5a5a)),text:profile[index].bio)),
                  trailing:FutureBuilder(
                    future: profileRepository.checkIfExist(profile[index].login).then((value) => val= value),
                    builder: (context,waiter) {
                      return Container(height: 30, width: 30, child:
                      waiter.hasData==true
                          ?val == false ? Container() : Icon(
                        Icons.save, size: 30, color: Colors.green,)
                          :CircularProgressIndicator()
                     );}),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      child: const Text('Open Profile'),
                      onPressed: () {Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BlocProvider(
                          create: (context) => ProfileBloc(DataRepository()),
                          child:GitProfile(profile[index].login),
                        ),),).then((value) => notifyParent.call());},
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