import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_corns/constants/constants.dart';
import 'home.dart';

/*
 * IT17050272 - D. Manoj Kumar
 * 
 * splash.dart file is the first page of this app. Once the user opens the app,
 * the user interfce which is created by using the source code in this dart file will 
 * be displayed.
 * According to the below mentioed code, we included login page as our spalsh screen
 */

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  initState() {
    FirebaseAuth.instance
        .currentUser()
        .then((FirebaseUser currentUser) => {
              //if there is no current user logged into the app, then the system will redirect to login screen
              if (currentUser == null)
                Navigator.pushReplacementNamed(context, "/login")
              else
                {
                  //If there is an user already logged into the system, then redirect to home page
                  Firestore.instance
                      .collection("users")
                      .document(currentUser.toString())
                      .get()
                      .then((DocumentSnapshot result) =>
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(
                                        title: TitleConstants.ALL_MOVIES,
                                      ))))
                      .catchError((err) => print(err))
                }
            })
        .catchError((err) => print(err));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(child: CircularProgressIndicator()),
      ),
    );
  }
}
