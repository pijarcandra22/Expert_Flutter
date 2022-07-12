part of 'movie_detail_bloc.dart';

abstract class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object> get props => [];
}

class MovieDetailEmpty extends MovieDetailState {}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailError extends MovieDetailState {
  final String message;

  MovieDetailError(this.message);

  @override
  List<Object> get props => [message];
}

class MovieDetailHasData extends MovieDetailState {
  final MovieDetail result;
  final List<Movie> recommendations;

  MovieDetailHasData(this.result, this.recommendations);
}

class MovieRecomendationLoading extends MovieDetailState {}

class MovieRecomendationError extends MovieDetailState {
  final String message;

  MovieRecomendationError(this.message);

  @override
  List<Object> get props => [message];
}

abstract class WatchlistStatusMovieState extends Equatable {
  const WatchlistStatusMovieState();

  @override
  List<Object> get props => [];
}

class WatchlistStatusMovieEmpty extends WatchlistStatusMovieState {}

class WatchlistStatusMovieLoading extends WatchlistStatusMovieState {}

class WatchlistStatusMovieLoaded extends WatchlistStatusMovieState {
  final bool isAdded;

  WatchlistStatusMovieLoaded(this.isAdded);

  @override
  List<Object> get props => [isAdded];
}

class WatchlistStatusMovieError extends WatchlistStatusMovieState {
  final String message;
  final Function retry;

  WatchlistStatusMovieError(this.message, {required this.retry});

  @override
  List<Object> get props => [message];
}

class WatchlistStatusMovieSuccess extends WatchlistStatusMovieState {
  final String message;

  WatchlistStatusMovieSuccess(this.message);

  @override
  List<Object> get props => [message];
}
