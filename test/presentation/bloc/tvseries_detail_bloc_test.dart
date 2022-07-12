import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_tvseries_detail.dart';
import 'package:ditonton/domain/usecases/get_tvseries_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tvseries.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tvseries.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tvseries.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tvseries.dart';
import 'package:ditonton/presentation/bloc/tvseries_detail/tvseries_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist/watchlist_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tvseries_detail_bloc_test.mocks.dart';
import 'watchlist_bloc_test.mocks.dart';

@GenerateMocks([GetTVSeriesDetail,GetTVSeriesRecommendations,WatchlistTVSeriesBloc,GetWatchListStatusTVSeries,SaveWatchlistTVSeries,RemoveWatchlistTVSeries])
void main() {
  late WatchlistTVSeriesBloc watchlistBloc;
  late GetWatchlistTVSeries getWatchlist;
  late GetWatchListStatusTVSeries getWatchListStatus;
  late SaveWatchlistTVSeries saveWatchlist;
  late RemoveWatchlistTVSeries removeWatchlist;
  late GetTVSeriesDetail getTVSeriesDetail;
  late GetTVSeriesRecommendations getTVSeriesRecommendations;
  late TVSeriesDetailBloc detailBloc;
  late WatchlistStatusTVSeriesBloc watchlistStatusBloc;

  setUp(() {
    getWatchlist = MockGetWatchlistTVSeries();
    getWatchListStatus = MockGetWatchListStatusTVSeries();
    saveWatchlist = MockSaveWatchlistTVSeries();
    removeWatchlist = MockRemoveWatchlistTVSeries();
    getTVSeriesDetail = MockGetTVSeriesDetail();
    getTVSeriesRecommendations = MockGetTVSeriesRecommendations();
    detailBloc = TVSeriesDetailBloc(getTVSeriesDetail, getTVSeriesRecommendations);
    watchlistBloc = WatchlistTVSeriesBloc(getWatchlist);
    watchlistStatusBloc = WatchlistStatusTVSeriesBloc(
        watchlistBloc, getWatchListStatus, saveWatchlist, removeWatchlist);
  });

  final tId = 1;

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovies = <Movie>[tMovie];

  test('inital state should be initial', () {
    expect(detailBloc.state, TVSeriesDetailEmpty());
  });

  test('inital state should be empty', () {
    expect(watchlistStatusBloc.state, WatchlistStatusTVSeriesEmpty());
  });

  blocTest('Should emit [Loading, HasData] when data added succesful',
      build: () {
        when(saveWatchlist.execute(testTVSeriesDetail))
            .thenAnswer((_) async => Right('Success'));
        when(getWatchListStatus.execute(testTVSeriesDetail.id))
            .thenAnswer((_) async => true);
        when(getWatchlist.execute()).thenAnswer((_) async => Right([testWatchlistTVSeries]));

        return watchlistStatusBloc;
      },
      act: (WatchlistStatusTVSeriesBloc watchlistStatusBloc) => watchlistStatusBloc.add(OnWatchlistAdded(testTVSeriesDetail)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        WatchlistStatusTVSeriesLoading(),
        WatchlistStatusTVSeriesSuccess('Success Added title to watchlist'),
        WatchlistStatusTVSeriesLoaded(true)
      ],
      verify: (WatchlistStatusTVSeriesBloc watchlistStatusBloc) {
        verify(saveWatchlist.execute(testTVSeriesDetail));
        verify(getWatchListStatus.execute(testTVSeriesDetail.id));
      });

  blocTest('Should emit [Loading, HasData] when data removed succesful',
      build: () {
        when(removeWatchlist.execute(testTVSeriesDetail))
            .thenAnswer((_) async => Right('Removed'));
        when(getWatchListStatus.execute(testTVSeriesDetail.id))
            .thenAnswer((_) async => false);
        when(getWatchlist.execute()).thenAnswer((_) async => Right([]));

        return watchlistStatusBloc;
      },
      act: (WatchlistStatusTVSeriesBloc watchlistStatusBloc) =>
          watchlistStatusBloc.add(OnWatchlistRemoved(testTVSeriesDetail)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        WatchlistStatusTVSeriesLoading(),
        WatchlistStatusTVSeriesSuccess('Success Removed'),
        WatchlistStatusTVSeriesLoaded(false)
      ],
      verify: (WatchlistStatusTVSeriesBloc watchlistStatusBloc) {
        verify(removeWatchlist.execute(testTVSeriesDetail));
        verify(getWatchListStatus.execute(testTVSeriesDetail.id));
        verify(getWatchlist.execute());
      });

  blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(getTVSeriesRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tMovies));
      when(getTVSeriesDetail.execute(tId))
          .thenAnswer((_) async => Right(testTVSeriesDetail));
      return detailBloc;
    },
    act: (detailBloc) => detailBloc.add(TVSeriesDetailData(tId)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TVSeriesDetailLoading(),
      TVSeriesRecomendationLoading(),
      TVSeriesDetailHasData(testTVSeriesDetail,tMovies),
    ],
    verify: (bloc) {
      verify(getTVSeriesDetail.execute(tId));
      verify(getTVSeriesRecommendations.execute(tId));
    },
  );

  blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(getTVSeriesRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(getTVSeriesDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return detailBloc;
    },
    act: (detailBloc) => detailBloc.add(TVSeriesDetailData(tId)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TVSeriesDetailLoading(),
      TVSeriesDetailError('Server Failure'),
    ],
    verify: (bloc) {
      verify(getTVSeriesDetail.execute(tId));
      verify(getTVSeriesRecommendations.execute(tId));
    },
  );
}