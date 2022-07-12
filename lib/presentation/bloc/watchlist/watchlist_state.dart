part of 'watchlist_bloc.dart';

abstract class WatchlistState extends Equatable {
  const WatchlistState();

  @override
  List<Object> get props => [];
}

class WatchlistInitial extends WatchlistState {}

class WatchlistLoading extends WatchlistState {}

class WatchlistEmpty extends WatchlistState {}

class WatchlistHasData extends WatchlistState {
  final List<Movie> data;

  WatchlistHasData(this.data);

  @override
  List<Object> get props => [...data];
}

class WatchlistError extends WatchlistState {
  final String message;
  final Function retry;

  WatchlistError(this.message, {required this.retry});

  @override
  List<Object> get props => [message];
}

abstract class WatchlistTVSeriesState extends Equatable {
  const WatchlistTVSeriesState();

  @override
  List<Object> get props => [];
}

class WatchlistTVSeriesInitial extends WatchlistTVSeriesState {}

class WatchlistTVSeriesLoading extends WatchlistTVSeriesState {}

class WatchlistTVSeriesEmpty extends WatchlistTVSeriesState {}

class WatchlistTVSeriesHasData extends WatchlistTVSeriesState {
  final List<Movie> data;

  WatchlistTVSeriesHasData(this.data);

  @override
  List<Object> get props => [...data];
}

class WatchlistTVSeriesError extends WatchlistTVSeriesState {
  final String message;
  final Function retry;

  WatchlistTVSeriesError(this.message, {required this.retry});

  @override
  List<Object> get props => [message];
}
