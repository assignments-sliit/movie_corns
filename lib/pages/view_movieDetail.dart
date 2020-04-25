import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_corns/api/models/Movie.dart';
import 'package:movie_corns/api/services/auth.dart';

class ViewMovieDetailPage extends StatefulWidget {
  ViewMovieDetailPage({Key key, this.title, this.uid, this.movieId})
      : super(key: key); //update this to include the uid in the constructor
  final String title;
  final String uid; //include this
  final String movieId;

  @override
  _ViewMovieDetailPageState createState() => _ViewMovieDetailPageState();
}

class _ViewMovieDetailPageState extends State<ViewMovieDetailPage> {
  bool _visible = false;
  final Auth auth = new Auth();

  //Top Navigation
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Selected Movie"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Sign Out"),
                        content: Text("Are you sure want to sign out?"),
                        actions: [
                          FlatButton(
                            child: Text("CANCEL"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: Text("YES"),
                            onPressed: () {
                              auth.signOut();
                              print('User signout Complete');
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
    Widget okButton = FlatButton(
      child: Text("Test"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    return Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: new GestureDetector(
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMovieCard(String imgPath, Movie movie) {}

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
