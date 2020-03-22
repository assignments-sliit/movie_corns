import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  //final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  initState() {
    FirebaseAuth.instance
        .currentUser()
        .then((FirebaseUser currentUser) => {
              if (currentUser == null)
                Navigator.pushReplacementNamed(context, "/login")
              else
                {
                  Firestore.instance
                      .collection("users")
                      .document(currentUser.toString())
                      .get()
                      .then((DocumentSnapshot result) =>
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(
                                        title: 'All Movies ',
                                        //uid: currentUser.uid.toString(),
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
        child: Container(
          child: Text("Loading splash...."),
        ),
      ),
    );
  }
}