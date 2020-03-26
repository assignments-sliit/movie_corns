import 'package:flutter/material.dart';
import 'package:movie_corns/api/services/auth.dart';
import 'package:movie_corns/pages/login.dart';

class MoviePage extends StatefulWidget {
  MoviePage({Key key, this.title, this.uid, this.movieId})
      : super(key: key); //update this to include the uid in the constructor
  final String title;
  final String uid; //include this
  final String movieId;

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  final Auth auth= new Auth();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text("All Movies"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: (){
              auth.signOut();
              print('User signout Complete');
              Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage(
                                                
                                                )));
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          child: Text("HOME"),
        ),
      ),
    );
  }
}
