import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_corns/api/services/auth.dart';
import 'package:movie_corns/constants/constants.dart';

/*
* IT17143950 - G.M.A.S. Bastiansz

* The task of this add_review.dart file is providing a from to submit
* the review of the user for a selected movie. Use is able to provide 
* a comment & a rate (1-5) for the selected movie. Once the user submit
* the Add Movie Review form, the entered comment & rating store in Firebase
* database with the user ID, movie ID & the name of the selected movie 
*/

class AddReviewPage extends StatefulWidget {
  final movieId;
  final uid;
  final movieTitle;

  AddReviewPage({Key key, this.movieId, this.uid, this.movieTitle})
      : super(key: key);

  @override
  ReviewFormBodyState createState() => new ReviewFormBodyState();
}

class ReviewFormBodyState extends State<AddReviewPage> {
  final _formKey = GlobalKey<FormState>();
  final reference = Firestore.instance.collection('reviews').reference();
  double rating = 0.0;
  String review = "";

  //create a function for the toast
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

    //start 'Add Movie Review' page
    return Container(
        child: Scaffold(
      appBar: AppBar(
        title: Text(TitleConstants.ADD_MOVIE_REVIEW),
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
                            auth.signOut();
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

      //start 'Add Movie Review' form
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

                  //Start 'Comment' field
                  Padding(
                    padding: EdgeInsets.all(3.0),
                    child: Text(
                      LabelConstants.LABEL_COMMENT_FIELD,
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

                      //Validating the 'Comment' field for empty values
                      if (comment.isEmpty) {
                        return ValidatorConstants.COMMENT_CANNOT_NULL;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(10.0, 35.0, 10.0, 5.0),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: HintTextConstants.HINT_COMMENT_FIELD,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                  ),
                  //End 'Comment' field
                  //Start 'Rate Us' field
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      LabelConstants.LABEL_RATING_FIELD,
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
                          //print('The rating is $rating');
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
                  //End 'Rate Us' field
                  //Start button row
                  Padding(
                      padding: const EdgeInsets.fromLTRB(50.0, 20.0, 10.0, 5.0),
                      child: Row(
                        children: <Widget>[
                          //Start 'Submit Review' button
                          RaisedButton(
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                addReviewFirebase(
                                    review,
                                    rating,
                                    widget.movieId,
                                    widget.uid,
                                    widget.movieTitle);
                              }
                              Navigator.pushNamedAndRemoveUntil(
                                  context, "/home", (_) => false);

                              toast(
                                  ToastConstants.ADD_REVIEW_SUCCESS,
                                  Toast.LENGTH_LONG,
                                  ToastGravity.BOTTOM,
                                  Colors.blueGrey);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(19)),
                            color: Colors.blue,
                            child: Text(
                              ButtonConstants.ADD_REVIEW,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                            width: 50.0,
                          ),
                          //End 'Submit Review' button
                          //Start 'Cancel Review' button
                          RaisedButton(
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, "/movie", (_) => false);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(19)),
                            color: Colors.red,
                            child: Text(
                              ButtonConstants.CANCEL_REVIEW,
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                          //End 'Cancel Review' button
                        ],
                      )),
                  //End Button row
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }

  //this method is used to add the entered review to the system database
  void addReviewFirebase(String review, double rating, String movieId,
      String uid, String movieTitle) {
    Map<String, dynamic> data = Map();
    data['review'] = "$movieTitle - $review";
    data['rating'] = rating;
    data['movieId'] = movieId;
    data['uid'] = uid;

    reference.add(data);
  }
}
