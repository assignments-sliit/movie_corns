class Movie {
  String movieId;
  String movieTitle;
  String director;
  String movieImageUrl;
  String releaseYear;

  Movie({this.movieTitle, this.director, this.movieImageUrl, this.releaseYear});

  Movie.fromMap(Map snapshot, String movieId)
      : movieId = movieId ?? '',
        movieTitle = snapshot["movieTitle"],
        director = snapshot["director"],
        movieImageUrl = snapshot["movieImageUrl"],
        releaseYear = snapshot["releaseYear"];

  toJson() {
    return {
      "movieTitle": movieTitle,
      "director": director,
      "movieImageUrl": movieImageUrl,
      "releaseYear": releaseYear
    };
  }
  
}
