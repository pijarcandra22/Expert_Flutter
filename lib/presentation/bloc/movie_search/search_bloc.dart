import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/search_tvseries.dart';
import 'package:equatable/equatable.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:rxdart/rxdart.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMovies _searchMovies;

  SearchBloc(this._searchMovies) : super(SearchEmpty()) {
    on<OnQueryChanged>((event, emit) async {
      final query = event.query;

      emit(SearchLoading());
      final result = await _searchMovies.execute(query);

      result.fold(
            (failure) {
          emit(SearchError(failure.message));
        },
            (data) {
          emit(SearchHasData(data));
        },
      );
    },transformer: debounce(const Duration(milliseconds: 500)));
  }
}

class TVSeriesSearchBloc extends Bloc<SearchEvent, TVSeriesSearchState> {
  final SearchTVSeries _searchTVSeries;

  TVSeriesSearchBloc(this._searchTVSeries) : super(TVSeriesSearchEmpty()) {
    on<OnQueryChanged>((event, emit) async {
      final query = event.query;

      emit(TVSeriesSearchLoading());
      final result = await _searchTVSeries.execute(query);

      result.fold(
            (failure) {
          emit(TVSeriesSearchError(failure.message));
        },
            (data) {
          emit(TVSeriesSearchHasData(data));
        },
      );
    },transformer: debounce(const Duration(milliseconds: 500)));
  }
}

EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}