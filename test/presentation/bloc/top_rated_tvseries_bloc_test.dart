import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/bloc/top_rated_tvseries/top_rated_tvseries_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'top_rated_tvseries_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTVSeries])
void main() {
  late GetTopRatedTVSeries getTopRatedTVSeries;
  late TopRatedTVSeriesBloc bloc;

  setUp(() {
    getTopRatedTVSeries = MockGetTopRatedTVSeries();
    bloc = TopRatedTVSeriesBloc(getTopRatedTVSeries);
  });

  final tTVSeries = testTVSeries;
  final tTVSeriesList = <Movie>[tTVSeries];
  final expected = tTVSeriesList;

  test('inital state should be initial', () {
    expect(bloc.state, TopRatedTVSeriesEmpty());
  });

  blocTest('Should emit [Loading, HasData] when data is gotten succesful',
      build: () {
        when(getTopRatedTVSeries.execute())
            .thenAnswer((realInvocation) async => Right(tTVSeriesList));

        return bloc;
      },
      act: (TopRatedTVSeriesBloc bloc) => bloc.add(OnTopRatedTVSeriesDataRequested()),
      wait: const Duration(milliseconds: 500),
      expect: () => [TopRatedTVSeriesLoading(), TopRatedTVSeriesHasData(expected)],
      verify: (TopRatedTVSeriesBloc bloc) {
        verify(getTopRatedTVSeries.execute());
      });

  blocTest('Should emit [Loading, Error] when data is gotten succesful',
      build: () {
        when(getTopRatedTVSeries.execute())
            .thenAnswer((realInvocation) async => Left(ServerFailure('Server Failure')));

        return bloc;
      },
      act: (TopRatedTVSeriesBloc bloc) => bloc.add(OnTopRatedTVSeriesDataRequested()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TopRatedTVSeriesLoading(),
        TopRatedTVSeriesError('Server Failure')
      ],
      verify: (TopRatedTVSeriesBloc bloc) {
        verify(getTopRatedTVSeries.execute());
      });
}