import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/movie_search/search_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/movie.dart';

part 'top_rated_movies_state.dart';
part 'top_rated_movies_event.dart';

class TopRatedMovieBloc extends Bloc<TopRatedMovieEvent, TopRatedMovieState> {
  TopRatedMovieBloc(GetTopRatedMovies getTopRatedMovie) : super(TopRatedMovieEmpty()) {
    on<OnTopRatedMovieDataRequested>((event, emit) async {
      emit(TopRatedMovieLoading());
      final result = await getTopRatedMovie.execute();

      result.fold(
            (failure) {
          emit(TopRatedMovieError(failure.message));
        },
            (data) {
          emit(TopRatedMovieHasData(data));
        },
      );
    },transformer: debounce(const Duration(milliseconds: 500)));
  }
}