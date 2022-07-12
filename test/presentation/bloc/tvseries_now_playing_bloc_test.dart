import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tvseries.dart';
import 'package:ditonton/presentation/bloc/tvseries_now_playing/tvseries_now_playing_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tvseries_now_playing_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingTVSeries])
void main() {
  late GetNowPlayingTVSeries getNowPlayingTVSeries;
  late NowPlayingTVSeriesBloc bloc;

  setUp(() {
    getNowPlayingTVSeries = MockGetNowPlayingTVSeries();
    bloc = NowPlayingTVSeriesBloc(getNowPlayingTVSeries);
  });

  final tTVSeries = testTVSeries;
  final tTVSeriesList = <Movie>[tTVSeries];
  final expected = tTVSeriesList;

  test('inital state should be initial', () {
    expect(bloc.state, NowPlayingTVSeriesEmpty());
  });

  blocTest('Should emit [Loading, HasData] when data is gotten succesful',
      build: () {
        when(getNowPlayingTVSeries.execute())
            .thenAnswer((realInvocation) async => Right(tTVSeriesList));

        return bloc;
      },
      act: (NowPlayingTVSeriesBloc bloc) => bloc.add(OnNowPlayingTVSeriesDataRequested()),
      wait: const Duration(milliseconds: 500),
      expect: () => [NowPlayingTVSeriesLoading(), NowPlayingTVSeriesHasData(expected)],
      verify: (NowPlayingTVSeriesBloc bloc) {
        verify(getNowPlayingTVSeries.execute());
      });

  blocTest('Should emit [Loading, Error] when data is gotten succesful',
      build: () {
        when(getNowPlayingTVSeries.execute())
            .thenAnswer((realInvocation) async => Left(ServerFailure('Server Failure')));

        return bloc;
      },
      act: (NowPlayingTVSeriesBloc bloc) => bloc.add(OnNowPlayingTVSeriesDataRequested()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        NowPlayingTVSeriesLoading(),
        NowPlayingTVSeriesError('Server Failure')
      ],
      verify: (NowPlayingTVSeriesBloc bloc) {
        verify(getNowPlayingTVSeries.execute());
      });
}