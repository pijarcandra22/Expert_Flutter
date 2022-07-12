part of 'movie_detail_bloc.dart';

abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();

  @override
  List<Object> get props => [];
}

class MovieDetailData extends MovieDetailEvent {
  final int id;

  MovieDetailData(this.id);

  @override
  List<Object> get props => [id];
}

abstract class WatchlistStatusMovieEvent extends Equatable {
  const WatchlistStatusMovieEvent();

  @override
  List<Object> get props => [];
}

class OnWatchlistAdded extends WatchlistStatusMovieEvent {
  final MovieDetail movie;

  OnWatchlistAdded(this.movie);

  @override
  List<Object> get props => [movie];
}

class OnWatchlistRemoved extends WatchlistStatusMovieEvent {
  final MovieDetail movie;

  OnWatchlistRemoved(this.movie);

  @override
  List<Object> get props => [movie];
}

class OnWatchlistStatusChecked extends WatchlistStatusMovieEvent {
  final int id;

  OnWatchlistStatusChecked(this.id);

  List<Object> get props => [id];
}