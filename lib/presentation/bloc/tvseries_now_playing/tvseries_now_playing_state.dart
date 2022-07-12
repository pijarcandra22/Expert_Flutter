part of 'tvseries_now_playing_bloc.dart';

abstract class NowPlayingTVSeriesState extends Equatable {
  const NowPlayingTVSeriesState();

  @override
  List<Object> get props => [];
}

class NowPlayingTVSeriesEmpty extends NowPlayingTVSeriesState {}

class NowPlayingTVSeriesLoading extends NowPlayingTVSeriesState {}

class NowPlayingTVSeriesHasData extends NowPlayingTVSeriesState {
  final List<Movie> movies;

  NowPlayingTVSeriesHasData(this.movies);

  @override
  List<Object> get props => [movies];
}

class NowPlayingTVSeriesError extends NowPlayingTVSeriesState {
  final String message;

  NowPlayingTVSeriesError(this.message);

  @override
  List<Object> get props => [message];
}
