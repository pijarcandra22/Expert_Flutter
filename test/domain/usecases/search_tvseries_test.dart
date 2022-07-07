import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/search_tvseries.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late SearchTVSeries usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = SearchTVSeries(mockMovieRepository);
  });

  final tMovies = <Movie>[];
  final tQuery = 'liar';

  test('should get list of movies from the repository', () async {
    // arrange
    when(mockMovieRepository.searchTVSeries(tQuery))
        .thenAnswer((_) async => Right(tMovies));
    // act
    final result = await usecase.execute(tQuery);
    // assert
    expect(result, Right(tMovies));
  });
}
