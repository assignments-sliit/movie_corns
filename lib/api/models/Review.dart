import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  String movieId;
  String reviewId;
  String uid;
  String content;
  num rating;
  Timestamp dateTime;
  String date;

  final DocumentReference documentReference;

  Review.fromMap(Map<String, dynamic> map, {this.documentReference})
      : assert(map['movieId'] != null),
        assert(map['reviewId'] != null),
        assert(map['uid'] != null),
        assert(map['content'] != null),
        assert(map['rating'] != null),
        movieId = map['movieId'],
        reviewId = map['reviewId'],
        uid = map['uid'],
        content = map['content'],
        rating = map['rating'],
        dateTime = map['date'];
  Review.fromSnapshot( DocumentSnapshot snapshot ) : this.fromMap(snapshot.data, documentReference: snapshot.reference);

}


