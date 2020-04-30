import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_corns/api/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:movie_corns/pages/add_review.dart';

class ViewMovieDetailPage extends StatelessWidget {
  final movieId;
  final uid;

  ViewMovieDetailPage({Key key, this.movieId, this.uid}) : super(key: key);

  final Auth auth = new Auth();
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text("Movie Details"),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, '/movie', (_) => false),
              ),
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
            body: _prepareDetailAndBody(context, movieId)));
  }

  Widget _prepareDetailAndBody(BuildContext context, String movieId) {
    return StreamBuilder<DocumentSnapshot>(
      stream:
          Firestore.instance.collection('movies').document(movieId).snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        return _movieDetailBody(context, snapshot.data);
      },
    );
  }

  Widget _movieDetailBody(BuildContext context, DocumentSnapshot snapshot) {
    print(uid);
    final rating = Container(
      padding: const EdgeInsets.all(7.0),
      decoration: new BoxDecoration(
          border: new Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(5.0)),
      child: new Text(
        snapshot["director"],
        style: TextStyle(color: Colors.white),
      ),
    );
    final cast = Container(
      padding: const EdgeInsets.all(7.0),
      decoration: new BoxDecoration(
          border: new Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(5.0)),
      child: new Text(
        snapshot["cast"],
        style: TextStyle(color: Colors.white),
      ),
    );
    final header = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(
          Icons.movie,
          color: Colors.white,
          size: 20.0,
        ),
        Container(
          width: 90.0,
          child: new Divider(
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          snapshot["movieTitle"],
          style: TextStyle(color: Colors.white, fontSize: 30.0),
        ),
        SizedBox(height: 20.0),
        Text('Directed by:', style: TextStyle(color: Colors.white)),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[Expanded(child: rating)],
        ),
        SizedBox(height: 10.0),
        Text(
          'Cast: ',
          style: TextStyle(color: Colors.white),
        ), //SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[Expanded(child: cast)],
        )
      ],
    );

    final headerContent = Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 10.0),
            height: MediaQuery.of(context).size.height * 0.52,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                  image:
                      new NetworkImage(getMovieUrl(snapshot["movieImageUrl"])),
                  fit: BoxFit.cover),
            )),
        Container(
          height: MediaQuery.of(context).size.height * 0.512,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color.fromRGBO(54, 60, 100, .9)),
          child: Center(
            child: header,
          ),
        ),
      ],
    );

    final movieDetail = Text(
      snapshot["description"],
      style: TextStyle(fontSize: 15.5),
    );

    final addReviewButton = Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        width: MediaQuery.of(context).size.width,
        child: RaisedButton.icon(
          icon: Icon(Icons.add, color: Colors.white),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
          onPressed: () => {
            //Amashi start
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddReviewPage(
                      uid: uid,
                      movieId: snapshot.documentID,
                    )))
            //Amashi end
          },
          color: Colors.blue,
          label: Text("ADD REVIEW", style: TextStyle(color: Colors.white)),
        ));

    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          children: <Widget>[movieDetail, addReviewButton],
        ),
      ),
    );

    //and fiiiinally..........
    return new Scaffold(
      body: Column(
        children: <Widget>[headerContent, bottomContent],
      ),
    );
  }

  String getMovieUrl(String snapUrl) {
    if (snapUrl.isEmpty)
      return "https://www.google.com/url?sa=i&url=http%3A%2F%2Fgearr.scannain.com%2Fmovies%2Fcharlie-lennon-ceol-on-gcroi%2F&psig=AOvVaw2yh_ZWeDf6OwCYaUroCkSU&ust=1588220621163000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCJi9_YHljOkCFQAAAAAdAAAAABAI";

    return snapUrl;
  }
}
