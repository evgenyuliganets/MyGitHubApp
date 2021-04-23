import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_github_app/repository/models/model.dart';


Column buildSingleRepoData(Repository repo) {
       return Column(
         children: [
           Column(
             children: [
               if(repo.name !=null)
                 SizedBox(height: 5),
               if(repo.name !=null)
                 Text(
                   repo.name,
                   style: TextStyle(
                     color: Color(0xff212121),
                     fontSize: 25,
                     fontWeight: FontWeight.bold,
                   ),
                 ),
               if(repo.owner !=null)
                 SizedBox(height: 5),
               if(repo.owner !=null)
                 Text(
                   'Owner: '+repo.owner,
                   style: TextStyle(
                     color: Color(0xff3e3e3e),
                     fontSize: 25,
                     fontWeight: FontWeight.bold,
                   ),
                 ),
               if(repo.description !=null)
                 SizedBox(height: 10),
               if(repo.description !=null)
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child:  Text(
                     'Description: '+repo.description,
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
                     if(repo.createdAt !=null)
                       Column(
                         children: [
                           Text(
                             repo.createdAt.toString(),
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

                     if(repo.language !=null)
                       Column(
                         children: [
                           Text(
                             repo.language.toString(),
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
           ),
         ],
       );
}