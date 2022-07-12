import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tvseries.dart';
import 'package:ditonton/presentation/bloc/watchlist/watchlist_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../provider/watchlist_movie_notifier_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies, GetWatchlistTVSeries])
void main() {
  late GetWatchlistMovies getWatchlist;
  late WatchlistBloc moviebloc;
  late GetWatchlistTVSeries getWatchlistTVSeries;
  late WatchlistTVSeriesBloc tvseriesbloc;

  setUp(() {
    getWatchlist = MockGetWatchlistMovies();
    moviebloc = WatchlistBloc(getWatchlist);
    getWatchlistTVSeries = MockGetWatchlistTVSeries();
    tvseriesbloc = WatchlistTVSeriesBloc(getWatchlistTVSeries);
  });

  final data = [testWatchlistMovie];
  final expected = data;
  final datatv = [testWatchlistTVSeries];
  final expectedtv = datatv;

  test('inital state should be initial', () {
    expect(moviebloc.state, WatchlistInitial());
  });

  test('inital state should be initial', () {
    expect(tvseriesbloc.state, WatchlistTVSeriesInitial());
  });

  blocTest('Should emit [Loading, HasData] when data is gotten succesful',
      build: () {
        when(getWatchlist.execute())
            .thenAnswer((realInvocation) async => Right(expected));

        return moviebloc;
      },
      act: (WatchlistBloc moviebloc) => moviebloc.add(OnWatchlistDataRequested()),
      wait: const Duration(milliseconds: 500),
      expect: () => [WatchlistLoading(), WatchlistHasData(expected)],
      verify: (WatchlistBloc moviebloc) {
        verify(getWatchlist.execute());
      });

  blocTest('Should emit [Loading, HasData] when data is gotten succesful',
      build: () {
        when(getWatchlistTVSeries.execute())
            .thenAnswer((realInvocation) async => Right(expectedtv));

        return tvseriesbloc;
      },
      act: (WatchlistTVSeriesBloc tvseriesbloc) => tvseriesbloc.add(OnWatchlistDataRequestedTVSeries()),
      wait: const Duration(milliseconds: 500),
      expect: () => [WatchlistTVSeriesLoading(), WatchlistTVSeriesHasData(expectedtv)],
      verify: (WatchlistTVSeriesBloc tvseriesbloc) {
        verify(getWatchlistTVSeries.execute());
      });

  blocTest(
    'Should emit [Loading, Empty] when data is empty and succesful',
    build: () {
      when(getWatchlist.execute())
          .thenAnswer((realInvocation) async => Right([]));

      return moviebloc;
    },
    act: (WatchlistBloc moviebloc) => moviebloc.add(OnWatchlistDataRequested()),
    wait: const Duration(milliseconds: 500),
    expect: () => [WatchlistLoading(), WatchlistEmpty()],
  );

  blocTest(
    'Should emit [Loading, Empty] when data is empty and succesful',
    build: () {
      when(getWatchlistTVSeries.execute())
          .thenAnswer((realInvocation) async => Right([]));

      return tvseriesbloc;
    },
    act: (WatchlistTVSeriesBloc tvseriesbloc) => tvseriesbloc.add(OnWatchlistDataRequestedTVSeries()),
    wait: const Duration(milliseconds: 500),
    expect: () => [WatchlistTVSeriesLoading(), WatchlistTVSeriesEmpty()],
  );
}