import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_github_app/database/repository/repo_repository.dart';
import 'package:my_github_app/repository/bloc/repository_bloc.dart';
import 'package:my_github_app/repository/data_repository/data_repository.dart';
import 'package:my_github_app/repository/models/model.dart';
import 'package:my_github_app/repository/view/repos_text_field.dart';
import 'package:my_github_app/repository/view/single_repository.dart';


ListView buildReposData(List<Repository> repos,Function() notifyParent) {
  var repoRepository= RepoRepository();
  bool val;
  return ListView.builder(//ListView
    shrinkWrap: true,
    itemCount: repos.length,
    itemBuilder: (BuildContext context, int index) {
      if(index==0){ // FirstElement
   return GestureDetector(
     onTap:() {
       Navigator.push(
         context,
         MaterialPageRoute(builder: (context) => BlocProvider(
           create: (context) => RepositoryBloc(RepoDataRepository()),
           child:SingleRepo(repos[index].owner,repos[index].name),
         ),),).then((value) => notifyParent.call());
     },
     child: Column(
      children: [
        Column(children:[RepoTextField(),]),//Search
      Column(
        children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children:[
          if(repos.first.name !=null)
            SizedBox(height: 5),
          if(repos.first.name !=null)
          Text(
            repos.first.name,
            style: TextStyle(
              color: Color(0xff212121),
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          FutureBuilder(
              future: repoRepository.checkIfExist(repos[index].name,repos[index].owner).then((value) => val= value),
              builder: (context,waiter) {
                return Container(height: 30, width: 30, child:
                waiter.connectionState==ConnectionState.done
                    ? val == false ? Container() :Icon(Icons.save, size: 30, color: Colors.green,)
                    :CircularProgressIndicator()
                );
              }),
        ]),
          if(repos.first.owner !=null)
            SizedBox(height: 5),
          if(repos.first.owner !=null)
            Text(
              'Owner: '+repos.first.owner,
              style: TextStyle(
                color: Color(0xff3e3e3e),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          if(repos.first.description !=null)
          SizedBox(height: 10),
          if(repos.first.description !=null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:  Text(
              'Description: '+repos.first.description,
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
                if(repos.first.createdAt !=null)
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
              title: Center(child:Column(mainAxisAlignment: MainAxisAlignment.start, children: [(repos[index].name==null? Container() :Text(repos[index].name)),
                ]),),
              subtitle:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                (repos[index].owner==null
                  ?Container()
                  :RichText(text:TextSpan(text:'Owner: ' +repos[index].owner,style: TextStyle(color:Color(0xff474747)),))),
                repos[index].description==null? Container() : RichText(overflow: TextOverflow.ellipsis,maxLines: 2, text:TextSpan(style: TextStyle(color: Color(
                  0xff5a5a5a)),text:'Description: '+repos[index].description)),
              ]),
              trailing: FutureBuilder(
                  future: repoRepository.checkIfExist(repos[index].name,repos[index].owner).then((value) => val= value),
                  builder: (context,waiter) {
                    return Container(height: 30, width: 30, child:
                    waiter.connectionState==ConnectionState.done
                        ? val == false ? Container() :Icon(Icons.save, size: 30, color: Colors.green,)
                        :CircularProgressIndicator()
                    );
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('Open Repository'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BlocProvider(
                        create: (context) => RepositoryBloc(RepoDataRepository()),
                        child:SingleRepo(repos[index].owner,repos[index].name),
                      ),),).then((value) => notifyParent.call());
                  },
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