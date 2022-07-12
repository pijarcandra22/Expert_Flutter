import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/presentation/bloc/tvseries_popular/tvseries_popular_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tvseries_popular_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTVSeries])
void main() {
  late GetPopularTVSeries getPopularTVSeries;
  late PopularTVSeriesBloc bloc;

  setUp(() {
    getPopularTVSeries = MockGetPopularTVSeries();
    bloc = PopularTVSeriesBloc(getPopularTVSeries);
  });

  final tTVSeries = testTVSeries;
  final tTVSeriesList = <Movie>[tTVSeries];
  final expected = tTVSeriesList;

  test('inital state should be initial', () {
    expect(bloc.state, PopularTVSeriesEmpty());
  });

  blocTest('Should emit [Loading, HasData] when data is gotten succesful',
      build: () {
        when(getPopularTVSeries.execute())
            .thenAnswer((realInvocation) async => Right(tTVSeriesList));

        return bloc;
      },
      act: (PopularTVSeriesBloc bloc) => bloc.add(OnPopularTVSeriesDataRequested()),
      wait: const Duration(milliseconds: 500),
      expect: () => [PopularTVSeriesLoading(), PopularTVSeriesHasData(expected)],
      verify: (PopularTVSeriesBloc bloc) {
        verify(getPopularTVSeries.execute());
      });

  blocTest('Should emit [Loading, Error] when data is gotten succesful',
      build: () {
        when(getPopularTVSeries.execute())
            .thenAnswer((realInvocation) async => Left(ServerFailure('Server Failure')));

        return bloc;
      },
      act: (PopularTVSeriesBloc bloc) => bloc.add(OnPopularTVSeriesDataRequested()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        PopularTVSeriesLoading(),
        PopularTVSeriesError('Server Failure')
      ],
      verify: (PopularTVSeriesBloc bloc) {
        verify(getPopularTVSeries.execute());
      });
}