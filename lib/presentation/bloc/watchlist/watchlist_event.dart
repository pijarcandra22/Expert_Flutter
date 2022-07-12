part of 'watchlist_bloc.dart';

abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object> get props => [];
}

class OnWatchlistDataRequested extends WatchlistEvent {}

abstract class WatchlistTVSeriesEvent extends Equatable {
  const WatchlistTVSeriesEvent();

  @override
  List<Object> get props => [];
}

class OnWatchlistDataRequestedTVSeries extends WatchlistTVSeriesEvent {}