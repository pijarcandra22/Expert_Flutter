import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tvseries.dart';
import 'package:ditonton/presentation/bloc/movie_search/search_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/movie.dart';

part 'tvseries_now_playing_state.dart';
part 'tvseries_now_playing_event.dart';

class NowPlayingTVSeriesBloc extends Bloc<NowPlayingTVSeriesEvent, NowPlayingTVSeriesState> {
  NowPlayingTVSeriesBloc(GetNowPlayingTVSeries getNowPlayingTVSeries) : super(NowPlayingTVSeriesEmpty()) {
    on<OnNowPlayingTVSeriesDataRequested>((event, emit) async {
      emit(NowPlayingTVSeriesLoading());
      final result = await getNowPlayingTVSeries.execute();

      result.fold(
            (failure) {
          emit(NowPlayingTVSeriesError(failure.message));
        },
            (data) {
          emit(NowPlayingTVSeriesHasData(data));
        },
      );
    },transformer: debounce(const Duration(milliseconds: 500)));
  }
}