import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/db/database_helper_TV.dart';
import 'package:ditonton/data/models/tvseries_table.dart';

abstract class TVSeriesLocalDataSource {
  Future<String> insertWatchlistTVSeries(TVSeriesTable movie);
  Future<String> removeWatchlistTVSeries(TVSeriesTable movie);
  Future<TVSeriesTable?> getTVSeriesById(int id);
  Future<List<TVSeriesTable>> getWatchlistTVSeries();
}

class TVSeriesLocalDataSourceImpl implements TVSeriesLocalDataSource {
  final DatabaseHelperTV databaseHelper;

  TVSeriesLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertWatchlistTVSeries(TVSeriesTable movie) async {
    try {
      await databaseHelper.insertWatchlistTVSeries(movie);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlistTVSeries(TVSeriesTable movie) async {
    try {
      await databaseHelper.removeWatchlistTVSeries(movie);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<TVSeriesTable?> getTVSeriesById(int id) async {
    final result = await databaseHelper.getTVSeriesById(id);
    if (result != null) {
      return TVSeriesTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<TVSeriesTable>> getWatchlistTVSeries() async {
    final result = await databaseHelper.getWatchlistTVSeries();
    return result.map((data) => TVSeriesTable.fromMap(data)).toList();
  }
}
