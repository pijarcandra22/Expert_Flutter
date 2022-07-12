import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tvseries_detail.dart';
import 'package:ditonton/domain/usecases/get_tvseries_detail.dart';
import 'package:ditonton/domain/usecases/get_tvseries_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tvseries.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tvseries.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tvseries.dart';
import 'package:ditonton/presentation/bloc/watchlist/watchlist_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tvseries_detail_state.dart';
part 'tvseries_detail_event.dart';

class TVSeriesDetailBloc extends Bloc<TVSeriesDetailEvent, TVSeriesDetailState> {
  final GetTVSeriesDetail getTVSeriesDetail;
  final GetTVSeriesRecommendations getTVSeriesRecommendations;

  TVSeriesDetailBloc(this.getTVSeriesDetail, this.getTVSeriesRecommendations) : super(TVSeriesDetailEmpty()){
    on<TVSeriesDetailData>((event, emit) async {
      final id = event.id;

      emit(TVSeriesDetailLoading());

      final detailResult = await getTVSeriesDetail.execute(id);
      final recommendationResult = await getTVSeriesRecommendations.execute(id);

      detailResult.fold(
        (failure) {
          emit(TVSeriesDetailError(failure.message));
        },
        (movie) {
          emit(TVSeriesRecomendationLoading());
          recommendationResult.fold(
            (failure) {
              emit(TVSeriesRecomendationError(failure.message));
            },
            (movies) {
              emit(TVSeriesDetailHasData(movie,movies));
            },
          );
        },
      );
    });
  }
}

class WatchlistStatusTVSeriesBloc
    extends Bloc<WatchlistStatusTVSeriesEvent, WatchlistStatusTVSeriesState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  WatchlistStatusTVSeriesBloc(
      WatchlistTVSeriesBloc watchlistBloc,
      GetWatchListStatusTVSeries getWatchListStatus,
      SaveWatchlistTVSeries saveWatchlist,
      RemoveWatchlistTVSeries removeWatchlist)
      : super(WatchlistStatusTVSeriesEmpty()) {
    on<WatchlistStatusTVSeriesEvent>((event, emit) async {
      if (event is OnWatchlistAdded) {
        await onWatchlistAdded(watchlistBloc, saveWatchlist, event.movie);
      } else if (event is OnWatchlistRemoved) {
        await onWatchListRemoved(watchlistBloc, removeWatchlist, event.movie);
      } else if (event is OnWatchlistStatusChecked) {
        await onWatchListStatusChecked(getWatchListStatus, event.id);
      }
    });
  }

  Future<void> onWatchListStatusChecked(GetWatchListStatusTVSeries getWatchListStatus,
      int id) async {
    final isAdded = await getWatchListStatus.execute(id);

    emit(WatchlistStatusTVSeriesLoaded(isAdded));
  }

  Future<void> onWatchListRemoved(WatchlistTVSeriesBloc watchlistBloc,
      RemoveWatchlistTVSeries removeWatchlist, TVSeriesDetail movie) async {
    emit(WatchlistStatusTVSeriesLoading());
    final result = await removeWatchlist.execute(movie);

    result.fold((failure) {
      final state = WatchlistStatusTVSeriesError(failure.message, retry: () {
        add(OnWatchlistRemoved(movie));
      });

      emit(state);
    }, (data) {
      final state = WatchlistStatusTVSeriesSuccess('Success Removed');
      emit(state);

      add(OnWatchlistStatusChecked(movie.id));

      watchlistBloc.add(OnWatchlistDataRequestedTVSeries());
    });
  }

  Future<void> onWatchlistAdded(WatchlistTVSeriesBloc watchlistBloc,
      SaveWatchlistTVSeries saveWatchlist, TVSeriesDetail movie) async {
    emit(WatchlistStatusTVSeriesLoading());
    final result = await saveWatchlist.execute(movie);

    result.fold((failure) {
      final state = WatchlistStatusTVSeriesError(failure.message, retry: () {
        add(OnWatchlistAdded(movie));
      });

      emit(state);
    }, (data) {
      final state = WatchlistStatusTVSeriesSuccess(
          'Success Added ${movie.title} to watchlist');
      emit(state);

      add(OnWatchlistStatusChecked(movie.id));
      watchlistBloc.add(OnWatchlistDataRequestedTVSeries());
    });
  }
}