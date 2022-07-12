part of 'movie_now_playing_bloc.dart';

abstract class NowPlayingMovieState extends Equatable {
  const NowPlayingMovieState();

  @override
  List<Object> get props => [];
}

class NowPlayingMovieEmpty extends NowPlayingMovieState {}

class NowPlayingMovieLoading extends NowPlayingMovieState {}

class NowPlayingMovieHasData extends NowPlayingMovieState {
  final List<Movie> movies;

  NowPlayingMovieHasData(this.movies);

  @override
  List<Object> get props => [movies];
}

class NowPlayingMovieError extends NowPlayingMovieState {
  final String message;

  NowPlayingMovieError(this.message);

  @override
  List<Object> get props => [message];
}
