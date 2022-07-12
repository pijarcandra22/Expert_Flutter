part of 'tvseries_popular_bloc.dart';

abstract class PopularTVSeriesState extends Equatable {
  const PopularTVSeriesState();

  @override
  List<Object> get props => [];
}

class PopularTVSeriesEmpty extends PopularTVSeriesState {}

class PopularTVSeriesLoading extends PopularTVSeriesState {}

class PopularTVSeriesHasData extends PopularTVSeriesState {
  final List<Movie> movies;

  PopularTVSeriesHasData(this.movies);

  @override
  List<Object> get props => [movies];
}

class PopularTVSeriesError extends PopularTVSeriesState {
  final String message;

  PopularTVSeriesError(this.message);

  @override
  List<Object> get props => [message];
}
