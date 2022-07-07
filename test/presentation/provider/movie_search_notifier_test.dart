import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/domain/usecases/search_tvseries.dart';
import 'package:ditonton/presentation/provider/movie_search_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_search_notifier_test.mocks.dart';

@GenerateMocks([SearchMovies, SearchTVSeries])
void main() {
  late MovieSearchNotifier provider;
  late MockSearchMovies mockSearchMovies;
  late MockSearchTVSeries mockSearchTVSeries;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockSearchMovies = MockSearchMovies();
    mockSearchTVSeries = MockSearchTVSeries();
    provider = MovieSearchNotifier(searchMovies: mockSearchMovies, searchTVSeries: mockSearchTVSeries)
      ..addListener(() {
        listenerCallCount += 1;
      });
  });

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

  group('search movies', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Right(tMovieList));
      // act
      provider.fetchMovieSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Loading);
    });

    test('should change search result data when data is gotten successfully',
        () async {
      // arrange
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Right(tMovieList));
      // act
      await provider.fetchMovieSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Loaded);
      expect(provider.searchResult, tMovieList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchMovieSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('search tvseries', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockSearchTVSeries.execute(tQueryTV))
          .thenAnswer((_) async => Right(tTVSeriesList));
      // act
      provider.fetchTVSeriesSearch(tQueryTV);
      // assert
      expect(provider.stateTVSeries, RequestState.Loading);
    });

    test('should change search result data when data is gotten successfully',
            () async {
          // arrange
          when(mockSearchTVSeries.execute(tQueryTV))
              .thenAnswer((_) async => Right(tTVSeriesList));
          // act
          await provider.fetchTVSeriesSearch(tQueryTV);
          // assert
          expect(provider.stateTVSeries, RequestState.Loaded);
          expect(provider.searchResultTV, tTVSeriesList);
          expect(listenerCallCount, 2);
        });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockSearchTVSeries.execute(tQueryTV))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTVSeriesSearch(tQueryTV);
      // assert
      expect(provider.stateTVSeries, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
