import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_corns/api/services/auth.dart';
import 'package:movie_corns/constants/constants.dart';
import 'package:movie_corns/pages/view_movieDetail.dart';

class MoviePage extends StatefulWidget {
  MoviePage({Key key, this.title, this.uid, this.movieId})
      : super(key: key); 
  final String title;
  final String uid; 
  final String movieId;
  final Auth auth = new Auth();

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  String userId = "";

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          userId = user?.uid;

          print(userId);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(TitleConstants.ALL_MOVIES),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(TitleConstants.ALERT_SIGN_OUT),
                        content: Text(PromptConstants.QUESTION_CONFIRM_SIGN_OUT),
                        actions: [
                          FlatButton(
                            child: Text(ButtonConstants.OPTION_CANCEL),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: Text(ButtonConstants.OPTION_YES),
                            onPressed: () {
                              widget.auth.signOut();
                              Navigator.pushNamedAndRemoveUntil(
                                  context, "/login", (_) => false);
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
          ],
        ),
        body: _buildMovieBody(context));
  }

  Widget _buildMovieBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('movies')
          .orderBy("releaseYear", descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        return _buildMovieList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildMovieList(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView.builder(
        primary: false,
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: snapshot.isEmpty ? 0 : snapshot.length,
        itemBuilder: (context, index) {
          return _buildMovieItem(context, snapshot[index]);
        });
  }

  Widget _buildMovieItem(BuildContext context, DocumentSnapshot snapshot) {
    return Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Container(
        height: MediaQuery.of(context).size.height / 2.8,
        width: MediaQuery.of(context).size.width,
        child: new GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewMovieDetailPage(
                          uid: userId,
                          movieId: snapshot.documentID,
                        )));
          },
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            elevation: 6.0,
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height / 3.5,
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        child: Image.network(
                          "${snapshot["movieImageUrl"]}",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 6.0,
                      right: 6.0,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0)),
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.star,
                                color: Colors.orange,
                                size: 10,
                              ),
                              Text(
                                getAverageRating(snapshot["movieId"]),
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 6.0,
                      left: 6.0,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.0)),
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            "${snapshot["releaseYear"]}",
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 7.0),
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "${snapshot["movieTitle"]}",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getAverageRating(String movieId) {
    int averagereview;
    int noOfDocs;
    Firestore.instance
        .collection('reviews')
        .where("movieId", isEqualTo: movieId)
        .getDocuments()
        .then((snap) => snap.documents.forEach((doc) => {
              averagereview = averagereview + doc.data["rating"],
              noOfDocs = noOfDocs + snap.documents.length
            }));
    return "5.0";
  }
}
