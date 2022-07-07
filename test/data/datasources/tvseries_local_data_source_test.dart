import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tvseries_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TVSeriesLocalDataSourceImpl dataSource;
  late MockDatabaseHelperTV mockDatabaseHelperTV;

  setUp(() {
    mockDatabaseHelperTV = MockDatabaseHelperTV();
    dataSource = TVSeriesLocalDataSourceImpl(databaseHelper: mockDatabaseHelperTV);
  });

  group('save watchlist', () {
    test('should return success message when insert to database is success',
            () async {
          // arrange
          when(mockDatabaseHelperTV.insertWatchlistTVSeries(testTVSeriesTable))
              .thenAnswer((_) async => 1);
          // act
          final result = await dataSource.insertWatchlistTVSeries(testTVSeriesTable);
          // assert
          expect(result, 'Added to Watchlist');
        });

    test('should throw DatabaseException when insert to database is failed',
            () async {
          // arrange
          when(mockDatabaseHelperTV.insertWatchlistTVSeries(testTVSeriesTable))
              .thenThrow(Exception());
          // act
          final call = dataSource.insertWatchlistTVSeries(testTVSeriesTable);
          // assert
          expect(() => call, throwsA(isA<DatabaseException>()));
        });
  });

  group('remove watchlist', () {
    test('should return success message when remove from database is success',
            () async {
          // arrange
          when(mockDatabaseHelperTV.removeWatchlistTVSeries(testTVSeriesTable))
              .thenAnswer((_) async => 1);
          // act
          final result = await dataSource.removeWatchlistTVSeries(testTVSeriesTable);
          // assert
          expect(result, 'Removed from Watchlist');
        });

    test('should throw DatabaseException when remove from database is failed',
            () async {
          // arrange
          when(mockDatabaseHelperTV.removeWatchlistTVSeries(testTVSeriesTable))
              .thenThrow(Exception());
          // act
          final call = dataSource.removeWatchlistTVSeries(testTVSeriesTable);
          // assert
          expect(() => call, throwsA(isA<DatabaseException>()));
        });
  });

  group('Get Movie Detail By Id', () {
    final tId = 1;

    test('should return Movie Detail Table when data is found', () async {
      // arrange
      when(mockDatabaseHelperTV.getTVSeriesById(tId))
          .thenAnswer((_) async => testTVSeriesMap);
      // act
      final result = await dataSource.getTVSeriesById(tId);
      // assert
      expect(result, testTVSeriesTable);
    });

    test('should return null when data is not found', () async {
      // arrange
      when(mockDatabaseHelperTV.getTVSeriesById(tId)).thenAnswer((_) async => null);
      // act
      final result = await dataSource.getTVSeriesById(tId);
      // assert
      expect(result, null);
    });
  });

  group('get watchlist movies', () {
    test('should return list of MovieTable from database', () async {
      // arrange
      when(mockDatabaseHelperTV.getWatchlistTVSeries())
          .thenAnswer((_) async => [testTVSeriesMap]);
      // act
      final result = await dataSource.getWatchlistTVSeries();
      // assert
      expect(result, [testTVSeriesTable]);
    });
  });
}
