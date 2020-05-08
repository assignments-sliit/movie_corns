import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:movie_corns/api/services/auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_corns/constants/constants.dart';

/*
 * IT17143950 - G.M.A.S. Bastiansz
 * 
 * The tasks of my_review.dart file are providing relavant user interfaces as well as
 * backend codes to view all the reviews provided by the logged user, update a selected review
 * & delete reviews. According to the below source code the logged user can view all the reviews he/she 
 * had provided to movies in a list view.  The list with seperate cards. Each card displays 
 * seperate review. One card view consists with the name of the movie which user had reviewed,
 * the review comment & also the rating. Also each card has "Edit" icon & "Delete" icon which
 * can be used to fulfill update & delete tasks respectively. 
 * According to the below code when the user clicks on Edit Icon, he'she will be able to update the 
 * review which already provided. In order to firestore query, the user can only update the comment he/she 
 * provided before. Once the "edit" icon clicks, the system will prompt a dialog box with the old comment. 
 * If user wishes to edit it, he/she can give the new comment & clicks on "Update" button. The app will
 * automatically redirect to the My Reviews page while replacing the new comment instead of old comment.
 * When the user clicks on "Delete" icon, the system will prompt an alert message to comfirm the delete task.
 * After user approves it, the system will erase the review from the whole database while refreshing to the 
 * My Reviews page without the deleted review
 * These are the overall tasks fulfill through this dart file      
 */

class MyReviewsPage extends StatefulWidget {
  final String title;
  final dynamic uid;
  final movieId;
  final reviewId;

  MyReviewsPage({Key key, this.title, this.uid, this.movieId, this.reviewId})
      : super(key: key);

  @override
  _MyReviewsPageState createState() => _MyReviewsPageState();
}

class _MyReviewsPageState extends State<MyReviewsPage> {
  final Auth auth = new Auth();

  Function toast(
      String msg, Toast toast, ToastGravity toastGravity, Color colors) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: toast,
        gravity: toastGravity,
        backgroundColor: colors,
        textColor: Colors.white,
        fontSize: 16.0);
  }

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
          title: Text(TitleConstants.MY_REVIEWS),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(TitleConstants.ALERT_SIGN_OUT),
                        content:
                            Text(PromptConstants.QUESTION_CONFIRM_SIGN_OUT),
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
        body: Container(child: _buildReviewBody(context)));
  }

  Widget _buildReviewBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('reviews')
          .where('uid', isEqualTo: uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data.documents.length < 1) {
          return Text(TitleConstants.NO_REVIEWS);
        } else {
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
            SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(TitleConstants.ALL_YOUR_REVIEWS),
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
                  ],
                ),
                subtitle: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text("${record.review}"),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: new Icon(Icons.edit),
                      color: Colors.green,
                      onPressed: () {
                        _displayReviewUpdateDialog(context, record);
                      },
                    ),
                    IconButton(
                        icon: new Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(TitleConstants.ALERT_WARNING),
                                  content: Text(PromptConstants
                                      .QUESTION_CONFIRM_REVIEW_DELETE),
                                  actions: <Widget>[
                                    FlatButton(
                                      child:
                                          Text(ButtonConstants.OPTION_CANCEL),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    FlatButton(
                                      child:
                                          Text(ButtonConstants.OPTION_DELETE),
                                      onPressed: () {
                                        final Firestore firestore =
                                            Firestore.instance;

                                        firestore
                                            .collection('reviews')
                                            .getDocuments()
                                            .then((snap) {
                                          for (DocumentSnapshot snapshot
                                              in snap.documents) {
                                            if (snapshot.documentID ==
                                                record.reference.documentID) {
                                              snapshot.reference.delete();
                                            }
                                          }
                                        });

                                        toast(
                                            ToastConstants
                                                .DELETE_REVIEW_SUCCESS,
                                            Toast.LENGTH_LONG,
                                            ToastGravity.BOTTOM,
                                            Colors.blueGrey);

                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              });
                        })
                  ],
                ),
                isThreeLine: true,
              ),
            ))));
  }

  _displayReviewUpdateDialog(BuildContext context, Record record) async {
    TextEditingController commentController = new TextEditingController();

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(TitleConstants.UPDATE_MOVIE_REVIEW),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: Container(
              height: 100,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: record.review),
                    )
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(ButtonConstants.OPTION_CANCEL),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                  child: Text(ButtonConstants.OPTION_UPDATE),
                  onPressed: () {
                    String commentText = "";

                    if (commentController.text.isEmpty) {
                      commentText = record.review;
                    } else {
                      commentText = record.review.split("-")[0] +
                          " - " +
                          commentController.text;
                    }

                    print(widget.uid);

                    Firestore.instance
                        .collection('reviews')
                        .document(record.reference.documentID)
                        .setData({
                      "review": commentText,
                      "rating": record.rating,
                      "movieId": record.movieId,
                      "uid": uid
                    });
                    Navigator.of(context).pop();

                    toast(
                        ToastConstants.UPDATE_REVIEW_SUCCESS,
                        Toast.LENGTH_LONG,
                        ToastGravity.BOTTOM,
                        Colors.blueGrey);

                    return true;
                  })
            ],
          );
        });
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
