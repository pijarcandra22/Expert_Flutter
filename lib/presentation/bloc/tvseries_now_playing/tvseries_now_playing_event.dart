part of 'tvseries_now_playing_bloc.dart';

abstract class NowPlayingTVSeriesEvent extends Equatable {
  const NowPlayingTVSeriesEvent();

  @override
  List<Object> get props => [];
}

class OnNowPlayingTVSeriesDataRequested extends NowPlayingTVSeriesEvent {}