
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tvseries.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'watchlist_event.dart';
part 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  WatchlistBloc(GetWatchlistMovies getWatchlistMovies) : super(WatchlistInitial()) {
    on<WatchlistEvent>((event, emit) async {
      if (event is OnWatchlistDataRequested) {
        await onWatchListDataRequested(getWatchlistMovies);
      }
    });
  }

  Future<void> onWatchListDataRequested(GetWatchlistMovies getWatchlistMovies) async {
    emit(WatchlistLoading());
    final result = await getWatchlistMovies.execute();

    result.fold((failure) {
      final state = WatchlistError(failure.message, retry: () {
        add(OnWatchlistDataRequested());
      });

      emit(state);
    }, (data) {
      if (data.isEmpty) {
        emit(WatchlistEmpty());
        return;
      }

      emit(WatchlistHasData(data));
    });
  }
}

class WatchlistTVSeriesBloc extends Bloc<WatchlistTVSeriesEvent, WatchlistTVSeriesState> {
  WatchlistTVSeriesBloc(GetWatchlistTVSeries getWatchlistTVSeries) : super(WatchlistTVSeriesInitial()) {
    on<WatchlistTVSeriesEvent>((event, emit) async {
      if (event is OnWatchlistDataRequestedTVSeries) {
        await onWatchListDataRequested(getWatchlistTVSeries);
      }
    });
  }

  Future<void> onWatchListDataRequested(GetWatchlistTVSeries getWatchlistTVSeries) async {
    emit(WatchlistTVSeriesLoading());
    final result = await getWatchlistTVSeries.execute();

    result.fold((failure) {
      final state = WatchlistTVSeriesError(failure.message, retry: () {
        add(OnWatchlistDataRequestedTVSeries());
      });

      emit(state);
    }, (data) {
      if (data.isEmpty) {
        emit(WatchlistTVSeriesEmpty());
        return;
      }

      emit(WatchlistTVSeriesHasData(data));
    });
  }
}