import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/domain/usecases/search_tvseries.dart';
import 'package:flutter/foundation.dart';

class MovieSearchNotifier extends ChangeNotifier {
  final SearchMovies searchMovies;
  final SearchTVSeries searchTVSeries;

  MovieSearchNotifier({required this.searchMovies, required this.searchTVSeries});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<Movie> _searchResult = [];
  List<Movie> get searchResult => _searchResult;

  RequestState _stateTVSeries = RequestState.Empty;
  RequestState get stateTVSeries => _stateTVSeries;

  List<Movie> _searchResultTV = [];
  List<Movie> get searchResultTV => _searchResultTV;

  String _message = '';
  String get message => _message;

  Future<void> fetchMovieSearch(String query) async {
    _state = RequestState.Loading;
    notifyListeners();

    final result2 = await searchMovies.execute(query);
    result2.fold(
          (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
          (data) {
        _searchResult = data;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTVSeriesSearch(String query) async {
    _stateTVSeries = RequestState.Loading;
    notifyListeners();

    final result = await searchTVSeries.execute(query);
    result.fold(
      (failure) {
        _message = failure.message;
        _stateTVSeries = RequestState.Error;
        notifyListeners();
      },
      (data) {
        _searchResultTV = data;
        _stateTVSeries = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
