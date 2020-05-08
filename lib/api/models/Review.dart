import 'package:cloud_firestore/cloud_firestore.dart';

/*
 * IT17143950 - G.M.A.S. Bastiansz
 * 
 * This Review.dart file is used to show the models in the "reviews" databse
 */

class Review {
  String movieId;
  String reviewId;
  String uid;
  String review;
  num rating;

  final DocumentReference documentReference;

  Review.fromMap(Map<String, dynamic> map, {this.documentReference})
      : assert(map['movieId'] != null),
        assert(map['reviewId'] != null),
        assert(map['uid'] != null),
        assert(map['review'] != null),
        assert(map['rating'] != null),
        movieId = map['movieId'],
        reviewId = map['reviewId'],
        uid = map['uid'],
        review = map['review'],
        rating = map['rating'];

  Review.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, documentReference: snapshot.reference);
}
