import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/bloc/movie_search/search_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/movie.dart';

part 'top_rated_tvseries_state.dart';
part 'top_rated_tvseries_event.dart';

class TopRatedTVSeriesBloc extends Bloc<TopRatedTVSeriesEvent, TopRatedTVSeriesState> {
  TopRatedTVSeriesBloc(GetTopRatedTVSeries getTopRatedTVSeries) : super(TopRatedTVSeriesEmpty()) {
    on<OnTopRatedTVSeriesDataRequested>((event, emit) async {
      emit(TopRatedTVSeriesLoading());
      final result = await getTopRatedTVSeries.execute();

      result.fold(
            (failure) {
          emit(TopRatedTVSeriesError(failure.message));
        },
            (data) {
          emit(TopRatedTVSeriesHasData(data));
        },
      );
    },transformer: debounce(const Duration(milliseconds: 500)));
  }
}