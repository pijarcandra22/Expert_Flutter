import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tvseries.dart';
import 'package:flutter/foundation.dart';

class WatchlistMovieNotifier extends ChangeNotifier {
  var _watchlistMovies = <Movie>[];
  List<Movie> get watchlistMovies => _watchlistMovies;

  var _watchlistState = RequestState.Empty;
  RequestState get watchlistState => _watchlistState;

  var _watchlistTVSeries = <Movie>[];
  List<Movie> get watchlistTVSeries => _watchlistTVSeries;

  var _watchlistTVState = RequestState.Empty;
  RequestState get watchlistTVState => _watchlistTVState;

  String _message = '';
  String get message => _message;

  WatchlistMovieNotifier({required this.getWatchlistMovies , required this.getWatchlistTVSeries});

  final GetWatchlistMovies getWatchlistMovies;
  final GetWatchlistTVSeries getWatchlistTVSeries;

  Future<void> fetchWatchlistTVSeries() async {
    _watchlistTVState = RequestState.Loading;
    notifyListeners();

    final result2 = await getWatchlistTVSeries.execute();
    result2.fold(
          (failure) {
        _watchlistTVState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
          (moviesData) {
        _watchlistTVState = RequestState.Loaded;
        _watchlistTVSeries = moviesData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchWatchlistMovies() async {
    _watchlistState = RequestState.Loading;
    notifyListeners();

    final result = await getWatchlistMovies.execute();
    result.fold(
      (failure) {
        _watchlistState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (moviesData) {
        _watchlistState = RequestState.Loaded;
        _watchlistMovies = moviesData;
        notifyListeners();
      },
    );
  }
}
