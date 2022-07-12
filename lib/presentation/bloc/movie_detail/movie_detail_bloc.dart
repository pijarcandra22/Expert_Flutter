import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/watchlist/watchlist_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'movie_detail_state.dart';
part 'movie_detail_event.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;

  MovieDetailBloc(this.getMovieDetail, this.getMovieRecommendations) : super(MovieDetailEmpty()){
    on<MovieDetailData>((event, emit) async {
      final id = event.id;

      emit(MovieDetailLoading());

      final detailResult = await getMovieDetail.execute(id);
      final recommendationResult = await getMovieRecommendations.execute(id);

      detailResult.fold(
        (failure) {
          emit(MovieDetailError(failure.message));
        },
        (movie) {
          emit(MovieRecomendationLoading());
          recommendationResult.fold(
            (failure) {
              emit(MovieRecomendationError(failure.message));
            },
            (movies) {
              emit(MovieDetailHasData(movie,movies));
            },
          );
        },
      );
    });
  }
}

class WatchlistStatusMovieBloc
    extends Bloc<WatchlistStatusMovieEvent, WatchlistStatusMovieState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  WatchlistStatusMovieBloc(
      WatchlistBloc watchlistBloc,
      GetWatchListStatus getWatchListStatus,
      SaveWatchlist saveWatchlist,
      RemoveWatchlist removeWatchlist)
      : super(WatchlistStatusMovieEmpty()) {
    on<WatchlistStatusMovieEvent>((event, emit) async {
      if (event is OnWatchlistAdded) {
        await onWatchlistAdded(watchlistBloc, saveWatchlist, event.movie);
      } else if (event is OnWatchlistRemoved) {
        await onWatchListRemoved(watchlistBloc, removeWatchlist, event.movie);
      } else if (event is OnWatchlistStatusChecked) {
        await onWatchListStatusChecked(getWatchListStatus, event.id);
      }
    });
  }

  Future<void> onWatchListStatusChecked(GetWatchListStatus getWatchListStatus,
      int id) async {
    final isAdded = await getWatchListStatus.execute(id);

    emit(WatchlistStatusMovieLoaded(isAdded));
  }

  Future<void> onWatchListRemoved(WatchlistBloc watchlistBloc,
      RemoveWatchlist removeWatchlist, MovieDetail movie) async {
    emit(WatchlistStatusMovieLoading());
    final result = await removeWatchlist.execute(movie);

    result.fold((failure) {
      final state = WatchlistStatusMovieError(failure.message, retry: () {
        add(OnWatchlistRemoved(movie));
      });

      emit(state);
    }, (data) {
      final state = WatchlistStatusMovieSuccess('Success Removed');
      emit(state);

      add(OnWatchlistStatusChecked(movie.id));

      watchlistBloc.add(OnWatchlistDataRequested());
    });
  }

  Future<void> onWatchlistAdded(WatchlistBloc watchlistBloc,
      SaveWatchlist saveWatchlist, MovieDetail movie) async {
    emit(WatchlistStatusMovieLoading());
    final result = await saveWatchlist.execute(movie);

    result.fold((failure) {
      final state = WatchlistStatusMovieError(failure.message, retry: () {
        add(OnWatchlistAdded(movie));
      });

      emit(state);
    }, (data) {
      final state = WatchlistStatusMovieSuccess(
          'Success Added ${movie.title} to watchlist');
      emit(state);

      add(OnWatchlistStatusChecked(movie.id));
      watchlistBloc.add(OnWatchlistDataRequested());
    });
  }
}