import 'package:flutter/material.dart';
import 'package:my_github_app/home/models/profile.dart';
import 'package:my_github_app/home/view/text_field.dart';


Column buildUserData(Profile profile) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      HomeTextField(),
      Column(
        children: [
          Container(
            width: 150,
            height: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(
                image: NetworkImage(profile.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            profile.name,
            style: TextStyle(
              color: Color(0xff2d2d2d),
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
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
                      "FOLLOWERS",
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
                      "FOLLOWING",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                if(profile.public_repos !=null)
                Column(
                  children: [
                    Text(
                      profile.public_repos.toString(),
                      style: TextStyle(
                        color: Color(0xff454545),
                        fontSize: 30,
                      ),
                    ),
                    Text(
                      "REPOSITORIES",
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