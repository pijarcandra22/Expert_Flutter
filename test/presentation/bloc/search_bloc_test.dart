import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/domain/usecases/search_tvseries.dart';
import 'package:ditonton/presentation/bloc/movie_search/search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_bloc_test.mocks.dart';

@GenerateMocks([SearchMovies,SearchTVSeries])
void main() {
  late SearchBloc searchBloc;
  late TVSeriesSearchBloc tvseriessearchBloc;
  late MockSearchMovies mockSearchMovies;
  late MockSearchTVSeries mockSearchTVSeries;

  final tMovieModel = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
    'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final tTVSeriesModel = Movie(
    adult: false,
    backdropPath: '/rQGBjWNveVeF8f2PGRtS85w9o9r.jpg',
    genreIds: [18, 9648],
    id: 31917,
    originalTitle: 'Pretty Little Liars',
    overview:"Based on the Pretty Little Liars series of young adult novels by Sara Shepard, the series follows the lives of four girls — Spencer, Hanna, Aria, and Emily — whose clique falls apart after the disappearance of their queen bee, Alison. One year later, they begin receiving messages from someone using the name \"A\" who threatens to expose their secrets — including long-hidden ones they thought only Alison knew.",
    popularity: 47.432451,
    posterPath: '/vC324sdfcS313vh9QXwijLIHPJp.jpg',
    releaseDate: '2010-06-08',
    title: 'Pretty Little Liars',
    video: false,
    voteAverage: 5.04,
    voteCount: 133,
  );

  final tMovieList = <Movie>[tMovieModel];
  final tQuery = 'spiderman';

  final tTVSeriesList = <Movie>[tTVSeriesModel];
  final tQueryTV = 'pretty little liars';

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    mockSearchTVSeries = MockSearchTVSeries();
    searchBloc = SearchBloc(mockSearchMovies);
    tvseriessearchBloc = TVSeriesSearchBloc(mockSearchTVSeries);
  });

  test('initial state should be empty', () {
    expect(searchBloc.state, SearchEmpty());
  });

  blocTest<SearchBloc, SearchState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Right(tMovieList));
      return searchBloc;
    },
    act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchLoading(),
      SearchHasData(tMovieList),
    ],
    verify: (bloc) {
      verify(mockSearchMovies.execute(tQuery));
    },
  );

  blocTest<SearchBloc, SearchState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return searchBloc;
    },
    act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchLoading(),
      SearchError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockSearchMovies.execute(tQuery));
    },
  );

  test('initial state should be empty', () {
    expect(tvseriessearchBloc.state, TVSeriesSearchEmpty());
  });

  blocTest<TVSeriesSearchBloc, TVSeriesSearchState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchTVSeries.execute(tQueryTV))
          .thenAnswer((_) async => Right(tTVSeriesList));
      return tvseriessearchBloc;
    },
    act: (bloc) => bloc.add(OnQueryChanged(tQueryTV)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TVSeriesSearchLoading(),
      TVSeriesSearchHasData(tTVSeriesList),
    ],
    verify: (bloc) {
      verify(mockSearchTVSeries.execute(tQueryTV));
    },
  );

  blocTest<TVSeriesSearchBloc, TVSeriesSearchState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSearchTVSeries.execute(tQueryTV))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvseriessearchBloc;
    },
    act: (bloc) => bloc.add(OnQueryChanged(tQueryTV)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TVSeriesSearchLoading(),
      TVSeriesSearchError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockSearchTVSeries.execute(tQueryTV));
    },
  );
}