import 'package:flutter/material.dart';

class MyReviewsPage extends StatefulWidget {
  MyReviewsPage({Key key, this.title, this.uid})
      : super(key: key); //update this to include the uid in the constructor
  final String title;
  final String uid; //include this

  @override
  _MyReviewsPageState createState() => _MyReviewsPageState();
}

class _MyReviewsPageState extends State<MyReviewsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text("MY REVIEWS"),
        ),
      ),
    );
  }
}
