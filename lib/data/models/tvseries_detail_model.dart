import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/domain/entities/tvseries_detail.dart';
import 'package:equatable/equatable.dart';

class TVSeriesDetailResponse extends Equatable {
  TVSeriesDetailResponse({
    required this.backdropPath,
    required this.genres,
    required this.homepage,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.voteAverage,
    required this.voteCount,
  });

  final String? backdropPath;
  final List<GenreModel> genres;
  final String homepage;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String posterPath;
  final String releaseDate;
  final String title;
  final double voteAverage;
  final int voteCount;

  factory TVSeriesDetailResponse.fromJson(Map<String, dynamic> json) =>
      TVSeriesDetailResponse(
        backdropPath: json["backdrop_path"],
        genres: List<GenreModel>.from(
            json["genres"].map((x) => GenreModel.fromJson(x))),
        homepage: json["homepage"],
        id: json["id"],
        originalLanguage: json["original_language"],
        originalTitle: json["original_name"],
        overview: json["overview"],
        popularity: json["popularity"].toDouble(),
        posterPath: json["poster_path"],
        releaseDate: json["first_air_date"],
        title: json["name"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
      );

  Map<String, dynamic> toJson() => {
    "backdrop_path": backdropPath,
    "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
    "homepage": homepage,
    "id": id,
    "original_language": originalLanguage,
    "original_title": originalTitle,
    "overview": overview,
    "popularity": popularity,
    "poster_path": posterPath,
    "release_date": releaseDate,
    "title": title,
    "vote_average": voteAverage,
    "vote_count": voteCount,
  };

  TVSeriesDetail toEntity() {
    return TVSeriesDetail(
      backdropPath: this.backdropPath,
      genres: this.genres.map((genre) => genre.toEntity()).toList(),
      id: this.id,
      originalTitle: this.originalTitle,
      overview: this.overview,
      posterPath: this.posterPath,
      releaseDate: this.releaseDate,
      title: this.title,
      voteAverage: this.voteAverage,
      voteCount: this.voteCount
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    backdropPath,
    genres,
    homepage,
    id,
    originalLanguage,
    originalTitle,
    overview,
    popularity,
    posterPath,
    releaseDate,
    title,
    voteAverage,
    voteCount,
  ];
}