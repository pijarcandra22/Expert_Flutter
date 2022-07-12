part of 'top_rated_tvseries_bloc.dart';

abstract class TopRatedTVSeriesState extends Equatable {
  const TopRatedTVSeriesState();

  @override
  List<Object> get props => [];
}

class TopRatedTVSeriesEmpty extends TopRatedTVSeriesState {}

class TopRatedTVSeriesLoading extends TopRatedTVSeriesState {}

class TopRatedTVSeriesHasData extends TopRatedTVSeriesState {
  final List<Movie> movies;

  TopRatedTVSeriesHasData(this.movies);

  @override
  List<Object> get props => [movies];
}

class TopRatedTVSeriesError extends TopRatedTVSeriesState {
  final String message;

  TopRatedTVSeriesError(this.message);

  @override
  List<Object> get props => [message];
}
