import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  Movie({
    this.adult,
    this.backdropPath,
    this.genreIds,
    required this.id,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.originalName,
    this.releaseDate,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
  });

  Movie.watchlist({
    required this.id,
    required this.overview,
    required this.posterPath,
    required this.title,
  });

  bool? adult;
  String? backdropPath;
  List<int>? genreIds;
  int id;
  String? originalTitle;
  String? overview;
  double? popularity;
  String? posterPath;
  String? releaseDate;
  String? title;
  bool? video;
  double? voteAverage;
  int? voteCount;
  String? originalName;

  @override
  List<Object?> get props => [
        adult,
        backdropPath,
        genreIds,
        id,
        originalTitle,
        overview,
        popularity,
        posterPath,
        releaseDate,
        title,
        video,
        voteAverage,
        voteCount,
        originalName,
      ];
}
