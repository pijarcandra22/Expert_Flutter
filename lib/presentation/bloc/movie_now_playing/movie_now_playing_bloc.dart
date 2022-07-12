import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/presentation/bloc/movie_search/search_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/movie.dart';

part 'movie_now_playing_state.dart';
part 'movie_now_playing_event.dart';

class NowPlayingMovieBloc extends Bloc<NowPlayingMovieEvent, NowPlayingMovieState> {
  NowPlayingMovieBloc(GetNowPlayingMovies getNowPlayingMovie) : super(NowPlayingMovieEmpty()) {
    on<OnNowPlayingMovieDataRequested>((event, emit) async {
      emit(NowPlayingMovieLoading());
      final result = await getNowPlayingMovie.execute();

      result.fold(
            (failure) {
          emit(NowPlayingMovieError(failure.message));
        },
            (data) {
          emit(NowPlayingMovieHasData(data));
        },
      );
    },transformer: debounce(const Duration(milliseconds: 500)));
  }
}