part of 'tvseries_detail_bloc.dart';

abstract class TVSeriesDetailEvent extends Equatable {
  const TVSeriesDetailEvent();

  @override
  List<Object> get props => [];
}

class TVSeriesDetailData extends TVSeriesDetailEvent {
  final int id;

  TVSeriesDetailData(this.id);

  @override
  List<Object> get props => [id];
}

abstract class WatchlistStatusTVSeriesEvent extends Equatable {
  const WatchlistStatusTVSeriesEvent();

  @override
  List<Object> get props => [];
}

class OnWatchlistAdded extends WatchlistStatusTVSeriesEvent {
  final TVSeriesDetail movie;

  OnWatchlistAdded(this.movie);

  @override
  List<Object> get props => [movie];
}

class OnWatchlistRemoved extends WatchlistStatusTVSeriesEvent {
  final TVSeriesDetail movie;

  OnWatchlistRemoved(this.movie);

  @override
  List<Object> get props => [movie];
}

class OnWatchlistStatusChecked extends WatchlistStatusTVSeriesEvent {
  final int id;

  OnWatchlistStatusChecked(this.id);

  List<Object> get props => [id];
}