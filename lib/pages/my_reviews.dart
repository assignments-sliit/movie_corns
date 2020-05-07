import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:movie_corns/pages/view_review.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
//import 'package:movie_corns/api/models/Movie.dart';
import 'package:movie_corns/api/services/auth.dart';

class MyReviewsPage extends StatefulWidget {
  final String title;
  final dynamic uid;
  final movieId; //include this
  final reviewId;

  MyReviewsPage({Key key, this.title, this.uid, this.movieId, this.reviewId})
      : super(key: key);

  //final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  _MyReviewsPageState createState() => _MyReviewsPageState();
}

class _MyReviewsPageState extends State<MyReviewsPage> {
  final Auth auth = new Auth();

  static final fullStar = Icon(
    Icons.star,
    color: Colors.blueAccent,
  );

  static final halfStar = Icon(
    Icons.star_half,
    color: Colors.blueAccent,
  );

  static final starBorder = Icon(
    Icons.star_border,
    color: Colors.blueAccent,
  );

  static final starRow = Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[fullStar, fullStar, fullStar, halfStar, starBorder],
  );
String uid = "";

 @override
  void initState() {
    super.initState();
    auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          uid = user?.uid;
        }
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Reviews"),
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
        body: Container(child: _buildReviewBody(context)));
  }

  Widget _buildReviewBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('reviews').where('uid',isEqualTo: uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data.documents.length <1) {
          return Text('You have no reviews!');
        }else{
        return _buildReviewList(context, snapshot.data.documents);

        }

      },
    );
  }

  Widget _buildReviewList(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(5.0),
              child: _displayStars(snapshot),
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Text('${snapshot.length} reviews'),
            )
          ],
        ),
        Row(
          children: <Widget>[
            SizedBox(height: 30.0,),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Text('All your reviews'),
            )
          ],
        ),
        Column(
          children: _buildReviewTiles(context, snapshot),
        )
      ],
    );
  }

  List<Widget> _buildReviewTiles(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    return (snapshot.map((data) => _buildReviewItem(context, data)).toList());
  }

  Widget _buildReviewItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
    return _buildReviewCard('imagePath', record);
  }

  Widget _buildReviewCard(String path, Record record) {
    return Padding(
        padding: EdgeInsets.only(),
        child: Container(
            //height: MediaQuery.of(context).size.height / 2.8,
            width: MediaQuery.of(context).size.width,
            child: new GestureDetector(
                child: new Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.rate_review),
                ),
                title: Row(
                  children: <Widget>[
                    SmoothStarRating(
                      allowHalfRating: false,
                      starCount: 5,
                      rating: record.rating.toDouble(),
                      size: 20.0,
                      filledIconData: Icons.star,
                      halfFilledIconData: Icons.star_border,
                      color: Colors.blueAccent,
                      borderColor: Colors.blue,
                      spacing: 0.0,
                    ),
                    IconButton(
                      icon: new Icon(Icons.edit),
                      color: Colors.green,
                      onPressed: () {},
                    ),
                    IconButton(
                        icon: new Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () {}),
                  ],
                ),
                subtitle: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(record.review),
                ),
                isThreeLine: true,
              ),
            ))));
  }

  double _calAvgReview(List<DocumentSnapshot> snapshot) {
    double sum = 0.0;

    for (var i = 0; i < snapshot.length; i++) {
      Record record = Record.fromSnapshot(snapshot[i]);
      sum += record.rating.toDouble();
    }

    return sum / snapshot.length;
  }

  Widget _displayStars(List<DocumentSnapshot> snapshot) {
    return SmoothStarRating(
      allowHalfRating: true,
      starCount: 5,
      rating: _calAvgReview(snapshot),
      size: 40.0,
      filledIconData: Icons.star,
      halfFilledIconData: Icons.star_half,
      color: Colors.blueAccent,
      borderColor: Colors.blue,
      spacing: 0.0,
    );
  }
}

class Record {
  String review;
  num rating;
  String movieId;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['review'] != null),
        assert(map['rating'] != null),
        assert(map['movieId'] != null),
        review = map['review'],
        rating = map['rating'],
        movieId = map['movieId'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record <$review>";
}
