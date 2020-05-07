import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_corns/api/services/auth.dart';

class AddReviewPage extends StatefulWidget {
  final movieId;
  final uid;

  AddReviewPage({Key key, this.movieId, this.uid}) : super(key: key);

  @override
  ReviewFormBodyState createState() => new ReviewFormBodyState();
}

class ReviewFormBodyState extends State<AddReviewPage> {
  final _formKey = GlobalKey<FormState>();
  final reference = Firestore.instance.collection('reviews').reference();
  double rating = 0.0;
  String review = "";
  DateTime ratingDate = DateTime.now();

  Function toast(
      String msg, Toast toast, ToastGravity toastGravity, Color colors) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: toast,
        gravity: toastGravity,
        timeInSecForIosWeb: 1,
        backgroundColor: colors,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    const edgeInsetValue = 8.0;
    final Auth auth = new Auth();

    print("Movie id:");
    print(widget.movieId.toString());

    print("User id:");
    print(widget.uid);

    return Container(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Add Review"),
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
      body: Container(
        padding: const EdgeInsets.fromLTRB(
            edgeInsetValue, 50.0, edgeInsetValue, edgeInsetValue),
        child: ListView(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 30.0,
                  ),
                  Padding(
                    padding: EdgeInsets.all(3.0),
                    child: Text(
                      "Comment",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20),
                    ),
                  ),
                  TextFormField(
                    maxLines: 4,
                    validator: (comment) {
                      setState(() {
                        this.review = comment;
                      });
                      if (comment.isEmpty) {
                        return 'Comment field cannot be empty';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(10.0, 35.0, 10.0, 5.0),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "We like to hear from you!!",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      "Rate Us",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: SmoothStarRating(
                      allowHalfRating: true,
                      onRatingChanged: (rateVal) {
                        setState(() {
                          rating = rateVal;
                          print('The rating is $rating');
                        });
                      },
                      starCount: 5,
                      rating: this.rating,
                      size: 40,
                      filledIconData: Icons.star,
                      halfFilledIconData: Icons.star_half,
                      color: Colors.blueAccent,
                      borderColor: Colors.blue,
                      spacing: 0.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(156.0, 20.0, 30.0, 5.0),
                    child: RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          addReviewFirebase(
                              review, rating, widget.movieId, widget.uid);
                        }
                        Navigator.pushNamedAndRemoveUntil(
                            context, "/home", (_) => false);

                        toast(
                            "Your review added successfully!!",
                            Toast.LENGTH_LONG,
                            ToastGravity.BOTTOM,
                            Colors.blueGrey);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(19)),
                      color: Colors.blue,
                      child: Text(
                        'SUBMIT',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }

  void addReviewFirebase(
      String review, double rating, String movieId, String uid) {
    Map<String, dynamic> data = Map();
    data['review'] = review;
    data['rating'] = rating;
    data['movieId'] = movieId;
    data['uid'] = uid;

    reference.add(data);
  }
}
