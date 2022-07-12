import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/presentation/bloc/movie_search/search_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/movie.dart';

part 'tvseries_popular_state.dart';
part 'tvseries_popular_event.dart';

class PopularTVSeriesBloc extends Bloc<PopularTVSeriesEvent, PopularTVSeriesState> {
  PopularTVSeriesBloc(GetPopularTVSeries getPopularTVSeries) : super(PopularTVSeriesEmpty()) {
    on<OnPopularTVSeriesDataRequested>((event, emit) async {
      emit(PopularTVSeriesLoading());
      final result = await getPopularTVSeries.execute();

      result.fold(
            (failure) {
          emit(PopularTVSeriesError(failure.message));
        },
            (data) {
          emit(PopularTVSeriesHasData(data));
        },
      );
    },transformer: debounce(const Duration(milliseconds: 500)));
  }
}