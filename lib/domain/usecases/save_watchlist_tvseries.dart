import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tvseries_detail.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';

class SaveWatchlistTVSeries {
  final MovieRepository repository;

  SaveWatchlistTVSeries(this.repository);

  Future<Either<Failure, String>> execute(TVSeriesDetail movie) {
    return repository.saveWatchlistTVSeries(movie);
  }
}
