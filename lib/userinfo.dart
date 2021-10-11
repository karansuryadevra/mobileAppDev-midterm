import 'package:midterm/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserInfo extends StatefulWidget {
  var users;
  UserInfo(this.users, {Key? key}) : super(key: key);

  @override
  _UserInfoState createState() => _UserInfoState(users);
}

class _UserInfoState extends State<UserInfo> {
  var users;
  _UserInfoState(this.users);

  @override
  Widget build(BuildContext context) {
    print(users);
    return Scaffold(
      appBar: AppBar(title: Text("User Info")),
      body: Center(
          // padding: EdgeInsets.symmetric(horizontal: 60, vertical: 90),
          child: Column(
        children: [
          SizedBox(
            height: 40.0,
          ),
          SizedBox(
            height: 150,
            width: 150,
            child: Image.network(users['displayPicture']),
          ),
          SizedBox(
            height: 20.0,
          ),
          Column(
              children: [
                Text("Name: " + users['firstName'] + " " + users['lastName'],
                    style: const TextStyle(
                      fontSize: 20.0,
                    )),
                Text("Bio: " + users['bio'],
                    style: const TextStyle(
                      fontSize: 20.0,
                    )),
                Text("Hometown: " + users['hometown'],
                    style: const TextStyle(
                      fontSize: 20.0,
                    )),
                Text("Age: " + users['age'],
                    style: const TextStyle(
                      fontSize: 20.0,
                    )),
              ],
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic)
        ],
        mainAxisAlignment: MainAxisAlignment.start,
      )),
    );
  }
}
