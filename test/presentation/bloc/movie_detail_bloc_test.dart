import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist/watchlist_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../provider/movie_detail_notifier_test.mocks.dart';
import '../provider/watchlist_movie_notifier_test.mocks.dart';

@GenerateMocks([GetMovieDetail,GetMovieRecommendations,WatchlistBloc,GetWatchListStatus,SaveWatchlist,RemoveWatchlist])
void main() {
  late WatchlistBloc watchlistBloc;
  late GetWatchlistMovies getWatchlist;
  late GetWatchListStatus getWatchListStatus;
  late SaveWatchlist saveWatchlist;
  late RemoveWatchlist removeWatchlist;
  late GetMovieDetail getMovieDetail;
  late GetMovieRecommendations getMovieRecommendations;
  late MovieDetailBloc detailBloc;
  late WatchlistStatusMovieBloc watchlistStatusBloc;

  setUp(() {
    getWatchlist = MockGetWatchlistMovies();
    getWatchListStatus = MockGetWatchListStatus();
    saveWatchlist = MockSaveWatchlist();
    removeWatchlist = MockRemoveWatchlist();
    getMovieDetail = MockGetMovieDetail();
    getMovieRecommendations = MockGetMovieRecommendations();
    detailBloc = MovieDetailBloc(getMovieDetail, getMovieRecommendations);
    watchlistBloc = WatchlistBloc(getWatchlist);
    watchlistStatusBloc = WatchlistStatusMovieBloc(
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
    expect(detailBloc.state, MovieDetailEmpty());
  });

  test('inital state should be empty', () {
    expect(watchlistStatusBloc.state, WatchlistStatusMovieEmpty());
  });

  blocTest('Should emit [Loading, HasData] when data added succesful',
      build: () {
        when(saveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Success'));
        when(getWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
        when(getWatchlist.execute()).thenAnswer((_) async => Right([testWatchlistMovie]));

        return watchlistStatusBloc;
      },
      act: (WatchlistStatusMovieBloc watchlistStatusBloc) => watchlistStatusBloc.add(OnWatchlistAdded(testMovieDetail)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        WatchlistStatusMovieLoading(),
        WatchlistStatusMovieSuccess('Success Added title to watchlist'),
        WatchlistStatusMovieLoaded(true)
      ],
      verify: (WatchlistStatusMovieBloc watchlistStatusBloc) {
        verify(saveWatchlist.execute(testMovieDetail));
        verify(getWatchListStatus.execute(testMovieDetail.id));
      });

  blocTest('Should emit [Loading, HasData] when data removed succesful',
      build: () {
        when(removeWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Removed'));
        when(getWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        when(getWatchlist.execute()).thenAnswer((_) async => Right([]));

        return watchlistStatusBloc;
      },
      act: (WatchlistStatusMovieBloc watchlistStatusBloc) =>
          watchlistStatusBloc.add(OnWatchlistRemoved(testMovieDetail)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        WatchlistStatusMovieLoading(),
        WatchlistStatusMovieSuccess('Success Removed'),
        WatchlistStatusMovieLoaded(false)
      ],
      verify: (WatchlistStatusMovieBloc watchlistStatusBloc) {
        verify(removeWatchlist.execute(testMovieDetail));
        verify(getWatchListStatus.execute(testMovieDetail.id));
        verify(getWatchlist.execute());
      });

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(getMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tMovies));
      when(getMovieDetail.execute(tId))
          .thenAnswer((_) async => Right(testMovieDetail));
      return detailBloc;
    },
    act: (detailBloc) => detailBloc.add(MovieDetailData(tId)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      MovieDetailLoading(),
      MovieRecomendationLoading(),
      MovieDetailHasData(testMovieDetail,tMovies),
    ],
    verify: (bloc) {
      verify(getMovieDetail.execute(tId));
      verify(getMovieRecommendations.execute(tId));
    },
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(getMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(getMovieDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return detailBloc;
    },
    act: (detailBloc) => detailBloc.add(MovieDetailData(tId)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      MovieDetailLoading(),
      MovieDetailError('Server Failure'),
    ],
    verify: (bloc) {
      verify(getMovieDetail.execute(tId));
      verify(getMovieRecommendations.execute(tId));
    },
  );

}