part of 'movie_now_playing_bloc.dart';

abstract class NowPlayingMovieEvent extends Equatable {
  const NowPlayingMovieEvent();

  @override
  List<Object> get props => [];
}

class OnNowPlayingMovieDataRequested extends NowPlayingMovieEvent {}