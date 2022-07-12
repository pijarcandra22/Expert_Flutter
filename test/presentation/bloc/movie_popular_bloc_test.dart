import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/presentation/bloc/movie_popular/movie_popular_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_popular_bloc_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late GetPopularMovies getPopularMovies;
  late PopularMovieBloc bloc;

  setUp(() {
    getPopularMovies = MockGetPopularMovies();
    bloc = PopularMovieBloc(getPopularMovies);
  });

  final tMovie = testMovie;
  final tMovieList = <Movie>[tMovie];
  final expected = tMovieList;

  test('inital state should be initial', () {
    expect(bloc.state, PopularMovieEmpty());
  });

  blocTest('Should emit [Loading, HasData] when data is gotten succesful',
      build: () {
        when(getPopularMovies.execute())
            .thenAnswer((realInvocation) async => Right(tMovieList));

        return bloc;
      },
      act: (PopularMovieBloc bloc) => bloc.add(OnPopularMovieDataRequested()),
      wait: const Duration(milliseconds: 500),
      expect: () => [PopularMovieLoading(), PopularMovieHasData(expected)],
      verify: (PopularMovieBloc bloc) {
        verify(getPopularMovies.execute());
      });

  blocTest('Should emit [Loading, Error] when data is gotten succesful',
      build: () {
        when(getPopularMovies.execute())
            .thenAnswer((realInvocation) async => Left(ServerFailure('Server Failure')));

        return bloc;
      },
      act: (PopularMovieBloc bloc) => bloc.add(OnPopularMovieDataRequested()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        PopularMovieLoading(),
        PopularMovieError('Server Failure')
      ],
      verify: (PopularMovieBloc bloc) {
        verify(getPopularMovies.execute());
      });
}