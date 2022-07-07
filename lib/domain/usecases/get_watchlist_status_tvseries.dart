import 'package:ditonton/domain/repositories/movie_repository.dart';

class GetWatchListStatusTVSeries {
  final MovieRepository repository;

  GetWatchListStatusTVSeries(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlistTVSeries(id);
  }
}
