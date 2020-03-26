//import 'dart:developer';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile.dart';
import 'movie.dart';
import 'my_reviews.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.uid})
      : super(key: key); //update this to include the uid in the constructor
  final String title;
  final String uid; //include this

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentTabIndex = 0;
  List<Widget> tabs = [MoviePage(), MyReviewsPage(), ProfilePage()];
  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Movie Corns"),
      // ),
      body: tabs[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapped,
        currentIndex: currentTabIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.movie), title: Text("Movies")),
          BottomNavigationBarItem(
              icon: Icon(Icons.star), title: Text("My Reviews")),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text("Profile"))
        ],
      ),
    );
  }
}
