import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tvseries_detail.dart';
import 'package:equatable/equatable.dart';

class TVSeriesTable extends Equatable {
  final int id;
  final String? title;
  final String? posterPath;
  final String? overview;

  TVSeriesTable({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
  });

  factory TVSeriesTable.fromEntity(TVSeriesDetail movie) => TVSeriesTable(
    id: movie.id,
    title: movie.title,
    posterPath: movie.posterPath,
    overview: movie.overview,
  );

  factory TVSeriesTable.fromMap(Map<String, dynamic> map) => TVSeriesTable(
    id: map['id'],
    title: map['title'],
    posterPath: map['posterPath'],
    overview: map['overview'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'posterPath': posterPath,
    'overview': overview,
  };

  Movie toEntity() => Movie.watchlist(
    id: id,
    overview: overview,
    posterPath: posterPath,
    title: title,
  );

  @override
  // TODO: implement props
  List<Object?> get props => [id, title, posterPath, overview];
}
