import 'package:bloc_test/bloc_test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import '../mock/mock_bloc.dart';

void main() {
  late MovieDetailBloc movieDetailBloc;
  late WatchlistStatusMovieBloc watchlistStatusMovieBloc;

  setUp(() {
    movieDetailBloc = MockMovieDetailBloc();
    watchlistStatusMovieBloc = MockWatchListStatusMovieBloc();
  });

  setUpAll(() {
    registerFallbackValue(MovieDetailStateFake());
    registerFallbackValue(MovieDetailEventFake());
    registerFallbackValue(WatchListStatusStateFake());
    registerFallbackValue(WatchListStatusEventFake());
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiProvider(
        providers: [
          BlocProvider(
            create: (_) => movieDetailBloc,
          ),
          BlocProvider(
            create: (context) => watchlistStatusMovieBloc,
          )
        ],
        child: Builder(
          builder: (_) => MaterialApp(home: body),
        ));
  }

  final movieDetail = testMovieDetail;
  final idMovie = movieDetail.id;
  final movieRecommendations = <Movie>[];
  final isAddedToWatchList = false;
  final imageUrl = '$BASE_IMAGE_URL${movieDetail.posterPath}';
  final contentData = movieDetail;

  testWidgets('Page should display center progress bar when loading',
          (tester) async {
        whenListen(movieDetailBloc, Stream.fromIterable([MovieDetailLoading()]),
            initialState: MovieDetailEmpty());

        final progressBarFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(
            _makeTestableWidget(MovieDetailPage(id: idMovie)));
        await tester.pump(Duration.zero);

        expect(centerFinder, findsOneWidget);
        expect(progressBarFinder, findsOneWidget);
      });
  testWidgets('Should has same data', (WidgetTester tester) async {
    whenListen(
        movieDetailBloc,
        Stream.fromIterable([
          MovieDetailLoading(),
          MovieDetailHasData(contentData, movieRecommendations)
        ]),
        initialState: MovieDetailEmpty());
    whenListen(
        watchlistStatusMovieBloc,
        Stream.fromIterable([
          WatchlistStatusMovieLoading(),
          WatchlistStatusMovieLoaded(isAddedToWatchList)
        ]),
        initialState: WatchlistStatusMovieEmpty());

    await tester.pumpWidget(
      _makeTestableWidget(MovieDetailPage(id: idMovie)),
    );
    await tester.pump(Duration.zero);

    expect(find.text(movieDetail.overview), findsOneWidget);
    expect(find.text(movieDetail.title), findsOneWidget);
    final image = find.byType(CachedNetworkImage).evaluate().single.widget
    as CachedNetworkImage;

    expect(image.imageUrl, imageUrl);
  });

  testWidgets('should show ditonton error widget when failure',
          (tester) async {
        whenListen(
            movieDetailBloc,
            Stream.fromIterable([
              MovieDetailLoading(),
              MovieDetailError('Server Failure')
            ]),
            initialState: MovieDetailEmpty());
        whenListen(
            watchlistStatusMovieBloc,
            Stream.fromIterable([
              WatchlistStatusMovieLoading(),
              WatchlistStatusMovieLoaded(isAddedToWatchList)
            ]),
            initialState: WatchlistStatusMovieEmpty());

        await tester.pumpWidget(
          _makeTestableWidget(MovieDetailPage(id: idMovie)),
        );
        await tester.pump(Duration.zero);
      });
}