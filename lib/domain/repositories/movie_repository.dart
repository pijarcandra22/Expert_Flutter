import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tvseries_detail.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/common/failure.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies();
  Future<Either<Failure, List<Movie>>> getPopularTVSeries();
  Future<Either<Failure, List<Movie>>> getTopRatedTVSeries();
  Future<Either<Failure, List<Movie>>> getPopularMovies();
  Future<Either<Failure, List<Movie>>> getTopRatedMovies();
  Future<Either<Failure, MovieDetail>> getMovieDetail(int id);
  Future<Either<Failure, List<Movie>>> getNowPlayingTVSeries();
  Future<Either<Failure, TVSeriesDetail>> getTVSeriesDetail(int id);
  Future<Either<Failure, List<Movie>>> getMovieRecommendations(int id);
  Future<Either<Failure, List<Movie>>> getTVSeriesRecommendations(int id);
  Future<Either<Failure, List<Movie>>> searchMovies(String query);
  Future<Either<Failure, List<Movie>>> searchTVSeries(String query);
  Future<Either<Failure, String>> saveWatchlist(MovieDetail movie);
  Future<Either<Failure, String>> removeWatchlist(MovieDetail movie);
  Future<bool> isAddedToWatchlist(int id);
  Future<Either<Failure, List<Movie>>> getWatchlistMovies();
  Future<Either<Failure, String>> saveWatchlistTVSeries(TVSeriesDetail movie);
  Future<Either<Failure, String>> removeWatchlistTVSeries(TVSeriesDetail movie);
  Future<bool> isAddedToWatchlistTVSeries(int id);
  Future<Either<Failure, List<Movie>>> getWatchlistTVSeries();
}
