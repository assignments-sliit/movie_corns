import 'package:flutter/material.dart';

class AddReviewPage extends StatefulWidget {
  AddReviewPage({Key key, this.title, this.uid,this.movieId}) : super(key: key); //update this to include the uid in the constructor
  final String title;
  final String uid; //include this
  final String movieId;

  @override
  _AddReviewPageState createState() => _AddReviewPageState();
}
class _AddReviewPageState extends State<AddReviewPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text("Welcome to add review page");
  }
}