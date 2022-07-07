import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tvseries.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:flutter/material.dart';

class MovieListNotifier extends ChangeNotifier {
  var _nowPlayingMovies = <Movie>[];
  List<Movie> get nowPlayingMovies => _nowPlayingMovies;

  RequestState _nowPlayingState = RequestState.Empty;
  RequestState get nowPlayingState => _nowPlayingState;

  var _nowPlayingTVSeries = <Movie>[];
  List<Movie> get nowPlayingTVSeries => _nowPlayingTVSeries;

  RequestState _nowPlayingTVSeriesState = RequestState.Empty;
  RequestState get nowPlayingTVSeriesState => _nowPlayingTVSeriesState;

  var _popularTVSeries = <Movie>[];
  List<Movie> get popularTVSeries => _popularTVSeries;

  RequestState _popularTVSeriesState = RequestState.Empty;
  RequestState get popularTVSeriesState => _popularTVSeriesState;

  var _topRatedTVSeries = <Movie>[];
  List<Movie> get topRatedTVSeries => _topRatedTVSeries;

  RequestState _topRatedTVSeriesState = RequestState.Empty;
  RequestState get topRatedTVSeriesState => _topRatedTVSeriesState;

  var _popularMovies = <Movie>[];
  List<Movie> get popularMovies => _popularMovies;

  RequestState _popularMoviesState = RequestState.Empty;
  RequestState get popularMoviesState => _popularMoviesState;

  var _topRatedMovies = <Movie>[];
  List<Movie> get topRatedMovies => _topRatedMovies;

  RequestState _topRatedMoviesState = RequestState.Empty;
  RequestState get topRatedMoviesState => _topRatedMoviesState;

  String _message = '';
  String get message => _message;

  MovieListNotifier({
    required this.getNowPlayingMovies,
    required this.getNowPlayingTVSeries,
    required this.getPopularTVSeries,
    required this.getTopRatedTVSeries,
    required this.getPopularMovies,
    required this.getTopRatedMovies,
  });

  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularTVSeries getPopularTVSeries;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedTVSeries getTopRatedTVSeries;
  final GetTopRatedMovies getTopRatedMovies;
  final GetNowPlayingTVSeries getNowPlayingTVSeries;

  Future<void> fetchNowPlayingMovies() async {
    _nowPlayingState = RequestState.Loading;
    notifyListeners();

    final result = await getNowPlayingMovies.execute();
    result.fold(
      (failure) {
        _nowPlayingState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (moviesData) {
        _nowPlayingState = RequestState.Loaded;
        _nowPlayingMovies = moviesData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchNowPlayingTVSeries() async {
    _nowPlayingTVSeriesState = RequestState.Loading;
    notifyListeners();

    final result = await getNowPlayingTVSeries.execute();
    result.fold(
          (failure) {
        _nowPlayingTVSeriesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
          (moviesData) {
        _nowPlayingTVSeriesState = RequestState.Loaded;
        _nowPlayingTVSeries = moviesData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularTVSeries() async {
    _popularTVSeriesState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTVSeries.execute();
    result.fold((failure) {
        _popularTVSeriesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },(moviesData) {
        _popularTVSeriesState = RequestState.Loaded;
        _popularTVSeries = moviesData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularMovies() async {
    _popularMoviesState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularMovies.execute();
    result.fold(
      (failure) {
        _popularMoviesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (moviesData) {
        _popularMoviesState = RequestState.Loaded;
        _popularMovies = moviesData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedMovies() async {
    _topRatedMoviesState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedMovies.execute();
    result.fold(
      (failure) {
        _topRatedMoviesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (moviesData) {
        _topRatedMoviesState = RequestState.Loaded;
        _topRatedMovies = moviesData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedTVSeries() async {
    _topRatedTVSeriesState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTVSeries.execute();
    result.fold(
          (failure) {
        _topRatedTVSeriesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
          (moviesData) {
        _topRatedTVSeriesState = RequestState.Loaded;
        _topRatedTVSeries = moviesData;
        notifyListeners();
      },
    );
  }
}
