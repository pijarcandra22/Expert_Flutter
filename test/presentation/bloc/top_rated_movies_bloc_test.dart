import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'top_rated_movies_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late GetTopRatedMovies getTopRatedMovies;
  late TopRatedMovieBloc bloc;

  setUp(() {
    getTopRatedMovies = MockGetTopRatedMovies();
    bloc = TopRatedMovieBloc(getTopRatedMovies);
  });

  final tMovie = testMovie;
  final tMovieList = <Movie>[tMovie];
  final expected = tMovieList;

  test('inital state should be initial', () {
    expect(bloc.state, TopRatedMovieEmpty());
  });

  blocTest('Should emit [Loading, HasData] when data is gotten succesful',
      build: () {
        when(getTopRatedMovies.execute())
            .thenAnswer((realInvocation) async => Right(tMovieList));

        return bloc;
      },
      act: (TopRatedMovieBloc bloc) => bloc.add(OnTopRatedMovieDataRequested()),
      wait: const Duration(milliseconds: 500),
      expect: () => [TopRatedMovieLoading(), TopRatedMovieHasData(expected)],
      verify: (TopRatedMovieBloc bloc) {
        verify(getTopRatedMovies.execute());
      });

  blocTest('Should emit [Loading, Error] when data is gotten succesful',
      build: () {
        when(getTopRatedMovies.execute())
            .thenAnswer((realInvocation) async => Left(ServerFailure('Server Failure')));

        return bloc;
      },
      act: (TopRatedMovieBloc bloc) => bloc.add(OnTopRatedMovieDataRequested()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TopRatedMovieLoading(),
        TopRatedMovieError('Server Failure')
      ],
      verify: (TopRatedMovieBloc bloc) {
        verify(getTopRatedMovies.execute());
      });
}