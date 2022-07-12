part of 'tvseries_detail_bloc.dart';

abstract class TVSeriesDetailState extends Equatable {
  const TVSeriesDetailState();

  @override
  List<Object> get props => [];
}

class TVSeriesDetailEmpty extends TVSeriesDetailState {}

class TVSeriesDetailLoading extends TVSeriesDetailState {}

class TVSeriesDetailError extends TVSeriesDetailState {
  final String message;

  TVSeriesDetailError(this.message);

  @override
  List<Object> get props => [message];
}

class TVSeriesDetailHasData extends TVSeriesDetailState {
  final TVSeriesDetail result;
  final List<Movie> recommendations;

  TVSeriesDetailHasData(this.result, this.recommendations);
}

class TVSeriesRecomendationLoading extends TVSeriesDetailState {}

class TVSeriesRecomendationError extends TVSeriesDetailState {
  final String message;

  TVSeriesRecomendationError(this.message);

  @override
  List<Object> get props => [message];
}

abstract class WatchlistStatusTVSeriesState extends Equatable {
  const WatchlistStatusTVSeriesState();

  @override
  List<Object> get props => [];
}

class WatchlistStatusTVSeriesEmpty extends WatchlistStatusTVSeriesState {}

class WatchlistStatusTVSeriesLoading extends WatchlistStatusTVSeriesState {}

class WatchlistStatusTVSeriesLoaded extends WatchlistStatusTVSeriesState {
  final bool isAdded;

  WatchlistStatusTVSeriesLoaded(this.isAdded);

  @override
  List<Object> get props => [isAdded];
}

class WatchlistStatusTVSeriesError extends WatchlistStatusTVSeriesState {
  final String message;
  final Function retry;

  WatchlistStatusTVSeriesError(this.message, {required this.retry});

  @override
  List<Object> get props => [message];
}

class WatchlistStatusTVSeriesSuccess extends WatchlistStatusTVSeriesState {
  final String message;

  WatchlistStatusTVSeriesSuccess(this.message);

  @override
  List<Object> get props => [message];
}
