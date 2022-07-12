import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/presentation/bloc/movie_now_playing/movie_now_playing_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_now_playing_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies])
void main() {
  late GetNowPlayingMovies getNowPlayingMovies;
  late NowPlayingMovieBloc bloc;

  setUp(() {
    getNowPlayingMovies = MockGetNowPlayingMovies();
    bloc = NowPlayingMovieBloc(getNowPlayingMovies);
  });

  final tMovie = testMovie;
  final tMovieList = <Movie>[tMovie];
  final expected = tMovieList;

  test('inital state should be initial', () {
    expect(bloc.state, NowPlayingMovieEmpty());
  });

  blocTest('Should emit [Loading, HasData] when data is gotten succesful',
      build: () {
        when(getNowPlayingMovies.execute())
            .thenAnswer((realInvocation) async => Right(tMovieList));

        return bloc;
      },
      act: (NowPlayingMovieBloc bloc) => bloc.add(OnNowPlayingMovieDataRequested()),
      wait: const Duration(milliseconds: 500),
      expect: () => [NowPlayingMovieLoading(), NowPlayingMovieHasData(expected)],
      verify: (NowPlayingMovieBloc bloc) {
        verify(getNowPlayingMovies.execute());
      });

  blocTest('Should emit [Loading, Error] when data is gotten succesful',
      build: () {
        when(getNowPlayingMovies.execute())
            .thenAnswer((realInvocation) async => Left(ServerFailure('Server Failure')));

        return bloc;
      },
      act: (NowPlayingMovieBloc bloc) => bloc.add(OnNowPlayingMovieDataRequested()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        NowPlayingMovieLoading(),
        NowPlayingMovieError('Server Failure')
      ],
      verify: (NowPlayingMovieBloc bloc) {
        verify(getNowPlayingMovies.execute());
      });
}