import 'package:flutter/material.dart';

class MoviePage extends StatefulWidget {
  MoviePage({Key key, this.title, this.uid,this.movieId}) : super(key: key); //update this to include the uid in the constructor
  final String title;
  final String uid; //include this
  final String movieId;

  @override
  _MoviePageState createState() => _MoviePageState();
}
class _MoviePageState extends State<MoviePage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}