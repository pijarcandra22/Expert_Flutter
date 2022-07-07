import 'package:ditonton/domain/usecases/get_watchlist_status_tvseries.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchListStatusTVSeries usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetWatchListStatusTVSeries(mockMovieRepository);
  });

  test('should get watchlist status from repository', () async {
    // arrange
    when(mockMovieRepository.isAddedToWatchlistTVSeries(1))
        .thenAnswer((_) async => true);
    // act
    final result = await usecase.execute(1);
    // assert
    expect(result, true);
  });
}
