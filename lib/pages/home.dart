import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.uid}) : super(key: key); //update this to include the uid in the constructor
  final String title;
  final String uid; //include this

  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text(widget.title),
        ),
      ),
    );
  }
}