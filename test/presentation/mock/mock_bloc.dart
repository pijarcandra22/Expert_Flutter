import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_popular/movie_popular_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated_tvseries/top_rated_tvseries_bloc.dart';
import 'package:ditonton/presentation/bloc/tvseries_detail/tvseries_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tvseries_popular/tvseries_popular_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

class MovieDetailStateFake extends Fake implements MovieDetailState {}

class MovieDetailEventFake extends Fake implements MovieDetailEvent {}

class MockTVSeriesDetailBloc extends MockBloc<TVSeriesDetailEvent, TVSeriesDetailState>
    implements TVSeriesDetailBloc {}

class TVSeriesDetailStateFake extends Fake implements TVSeriesDetailState {}

class TVSeriesDetailEventFake extends Fake implements TVSeriesDetailState {}

class MockWatchListStatusMovieBloc
    extends MockBloc<WatchlistStatusMovieEvent, WatchlistStatusMovieState>
    implements WatchlistStatusMovieBloc {}

class WatchListStatusStateFake extends Fake implements WatchlistStatusMovieState {}

class WatchListStatusEventFake extends Fake implements WatchlistStatusMovieEvent {}

class MockWatchListStatusTVSeriesBloc
    extends MockBloc<WatchlistStatusTVSeriesEvent, WatchlistStatusTVSeriesState>
    implements WatchlistStatusTVSeriesBloc {}

class WatchListStatusTVSeriesStateFake extends Fake implements WatchlistStatusTVSeriesState {}

class WatchListStatusTVSeriesEventFake extends Fake implements WatchlistStatusTVSeriesEvent {}

class MockPopularMovieBloc
    extends MockBloc<PopularMovieEvent, PopularMovieState>
    implements PopularMovieBloc {}

class PopularMovieStateFake extends Fake implements PopularMovieState {}

class PopularMovieEventFake extends Fake implements PopularMovieEvent {}

class MockPopularTVSeriesBloc
    extends MockBloc<PopularTVSeriesEvent, PopularTVSeriesState>
    implements PopularTVSeriesBloc {}

class PopularTVSeriesStateFake extends Fake implements PopularTVSeriesState {}

class PopularTVSeriesEventFake extends Fake implements PopularTVSeriesEvent {}

class MockTopRatedTVSeriesBloc
    extends MockBloc<TopRatedTVSeriesEvent, TopRatedTVSeriesState>
    implements TopRatedTVSeriesBloc {}

class TopRatedTVSeriesStateFake extends Fake implements TopRatedTVSeriesState {}

class TopRatedTVSeriesEventFake extends Fake implements TopRatedTVSeriesEvent {}

class MockTopRatedMovieBloc
    extends MockBloc<TopRatedMovieEvent, TopRatedMovieState>
    implements TopRatedMovieBloc {}

class TopRatedMovieStateFake extends Fake implements TopRatedMovieState {}

class TopRatedMovieEventFake extends Fake implements TopRatedMovieEvent {}
