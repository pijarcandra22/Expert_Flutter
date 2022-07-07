import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/common/failure.dart';

class GetTVSeriesRecommendations {
  final MovieRepository repository;

  GetTVSeriesRecommendations(this.repository);

  Future<Either<Failure, List<Movie>>> execute(id) {
    return repository.getTVSeriesRecommendations(id);
  }
}
