/*
 * IT17050272 - D. Manoj Kumar
 * 
 * This movieAPI.dart file is consisting with services which used to fetch movie details from
 * forebase
 */

class Movie {
  String movieId;
  String movieTitle;
  String director;
  String movieImageUrl;
  String releaseYear;
  String description;

  Movie(
      {this.movieTitle,
      this.director,
      this.movieImageUrl,
      this.releaseYear,
      this.description});

  Movie.fromMap(Map snapshot, String movieId)
      : movieId = movieId ?? '',
        movieTitle = snapshot["movieTitle"],
        director = snapshot["director"],
        movieImageUrl = snapshot["movieImageUrl"],
        releaseYear = snapshot["releaseYear"],
        description = snapshot["description"];

  toJson() {
    return {
      "movieTitle": movieTitle,
      "director": director,
      "movieImageUrl": movieImageUrl,
      "releaseYear": releaseYear,
      "description": description
    };
  }
}
