import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/presentation/bloc/movie_search/search_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/movie.dart';

part 'movie_popular_state.dart';
part 'movie_popular_event.dart';

class PopularMovieBloc extends Bloc<PopularMovieEvent, PopularMovieState> {
  PopularMovieBloc(GetPopularMovies getPopularMovies) : super(PopularMovieEmpty()) {
    on<OnPopularMovieDataRequested>((event, emit) async {
      emit(PopularMovieLoading());
      final result = await getPopularMovies.execute();

      result.fold(
            (failure) {
          emit(PopularMovieError(failure.message));
        },
            (data) {
          emit(PopularMovieHasData(data));
        },
      );
    },transformer: debounce(const Duration(milliseconds: 500)));
  }
}