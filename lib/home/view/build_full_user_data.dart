import 'package:flutter/material.dart';
import 'package:my_github_app/home/models/profile.dart';
import 'package:my_github_app/home/view/profile_full.dart';


Column buildUserFullData(Profile profile) {
        return Column(
            children: [
              Column(
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(profile.image,fit: BoxFit.cover,),
                      //Icon
                    ),
                  ),
                  if(profile.name !=null)
                  SizedBox(height: 10),
                  if(profile.name !=null)
                  Text(
                    profile.name,
                    style: TextStyle(
                      color: Color(0xff2d2d2d),
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if(profile.login !=null)
                  SizedBox(height: 10),
                  if(profile.login !=null)
                  Text(
                    profile.login,
                    style: TextStyle(
                      color: Color(0xff2d2d2d),
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if(profile.bio !=null)
                  SizedBox(height: 10),
                  if(profile.bio !=null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        profile.bio,
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
                        color: Color(0xFF2a2a2a).withOpacity(0.2),
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
                        if(profile.followers !=null)
                          Column(
                            children: [
                              Text(
                                profile.followers.toString(),
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
                        if(profile.following !=null)
                          Column(
                            children: [
                              Text(
                                profile.following.toString(),
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
                        if(profile.publicRepos !=null)
                          Column(
                            children: [
                              Text(
                                profile.publicRepos.toString(),
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
              ),
            ]);
      }
