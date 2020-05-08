import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_corns/api/models/Movie.dart';
import 'package:movie_corns/locator.dart';

/*
 * IT17050272 - D. Manoj Kumar
 * 
 * This movieAPI.dart file is consisting with services which used to fetch movie details from
 * forebase
 */

class MovieApi {
  final Firestore firestore = Firestore.instance;
  final String path;
  CollectionReference collectionReference;

  MovieApi(this.path) {
    collectionReference = firestore.collection(path);
  }

  Future<QuerySnapshot> getMovies() {
    return collectionReference.getDocuments();
  }

  Stream<QuerySnapshot> streamMovies() {
    return collectionReference.snapshots();
  }

  Future<DocumentSnapshot> getMovieByMovieId(String movieId) {
    return collectionReference.document(movieId).get();
  }
}

class MovieService extends ChangeNotifier {
  MovieApi movieApi = locator<MovieApi>();
  List<Movie> movies;

  Future<List<Movie>> fetchMovies() async {
    var result = await movieApi.getMovies();
    movies = result.documents
        .map((doc) => Movie.fromMap(doc.data, doc.documentID))
        .toList();
    return movies;
  }

  Stream<QuerySnapshot> fetchMoviesAsStream() {
    return movieApi.streamMovies();
  }

  Future<Movie> getMovieById(String movieId) async {
    var doc = await movieApi.getMovieByMovieId(movieId);
    return Movie.fromMap(doc.data, doc.documentID);
  }
}
