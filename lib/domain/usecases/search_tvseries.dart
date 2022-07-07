import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';

class SearchTVSeries {
  final MovieRepository repository;

  SearchTVSeries(this.repository);

  Future<Either<Failure, List<Movie>>> execute(String query) {
    return repository.searchTVSeries(query);
  }
}
