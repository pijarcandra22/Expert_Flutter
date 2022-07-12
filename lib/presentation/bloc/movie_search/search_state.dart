part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchEmpty extends SearchState {}

class SearchLoading extends SearchState {}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);

  @override
  List<Object> get props => [message];
}

class SearchHasData extends SearchState {
  final List<Movie> result;

  SearchHasData(this.result);

  @override
  List<Object> get props => [result];
}

abstract class TVSeriesSearchState extends Equatable {
  const TVSeriesSearchState();

  @override
  List<Object> get props => [];
}

class TVSeriesSearchEmpty extends TVSeriesSearchState {}

class TVSeriesSearchLoading extends TVSeriesSearchState {}

class TVSeriesSearchError extends TVSeriesSearchState {
  final String message;

  TVSeriesSearchError(this.message);

  @override
  List<Object> get props => [message];
}

class TVSeriesSearchHasData extends TVSeriesSearchState {
  final List<Movie> result;

  TVSeriesSearchHasData(this.result);

  @override
  List<Object> get props => [result];
}