part of 'top_rated_movies_bloc.dart';

abstract class TopRatedMovieEvent extends Equatable {
  const TopRatedMovieEvent();

  @override
  List<Object> get props => [];
}

class OnTopRatedMovieDataRequested extends TopRatedMovieEvent {}