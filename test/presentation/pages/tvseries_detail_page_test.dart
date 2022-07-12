import 'package:bloc_test/bloc_test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/tvseries_detail/tvseries_detail_bloc.dart';
import 'package:ditonton/presentation/pages/tvseries_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import '../mock/mock_bloc.dart';

void main() {
  late TVSeriesDetailBloc tvseriesDetailBloc;
  late WatchlistStatusTVSeriesBloc watchlistStatusTVSeriesBloc;

  setUp(() {
    tvseriesDetailBloc = MockTVSeriesDetailBloc();
    watchlistStatusTVSeriesBloc = MockWatchListStatusTVSeriesBloc();
  });

  setUpAll(() {
    registerFallbackValue(TVSeriesDetailStateFake());
    registerFallbackValue(TVSeriesDetailEventFake());
    registerFallbackValue(WatchListStatusStateFake());
    registerFallbackValue(WatchListStatusEventFake());
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiProvider(
        providers: [
          BlocProvider(
            create: (_) => tvseriesDetailBloc,
          ),
          BlocProvider(
            create: (context) => watchlistStatusTVSeriesBloc,
          )
        ],
        child: Builder(
          builder: (_) => MaterialApp(home: body),
        ));
  }

  final tvseriesDetail = testTVSeriesDetail;
  final idTVSeries = tvseriesDetail.id;
  final tvseriesRecommendations = <Movie>[];
  final isAddedToWatchList = false;
  final imageUrl = '$BASE_IMAGE_URL${tvseriesDetail.posterPath}';
  final contentData = tvseriesDetail;

  testWidgets('Page should display center progress bar when loading',
          (tester) async {
        whenListen(tvseriesDetailBloc, Stream.fromIterable([TVSeriesDetailLoading()]),
            initialState: TVSeriesDetailEmpty());

        final progressBarFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(
            _makeTestableWidget(TVSeriesDetailPage(id: idTVSeries)));
        await tester.pump(Duration.zero);

        expect(centerFinder, findsOneWidget);
        expect(progressBarFinder, findsOneWidget);
      });
  testWidgets('Should has same data', (WidgetTester tester) async {
    whenListen(
        tvseriesDetailBloc,
        Stream.fromIterable([
          TVSeriesDetailLoading(),
          TVSeriesDetailHasData(contentData, tvseriesRecommendations)
        ]),
        initialState: TVSeriesDetailEmpty());
    whenListen(
        watchlistStatusTVSeriesBloc,
        Stream.fromIterable([
          WatchlistStatusTVSeriesLoading(),
          WatchlistStatusTVSeriesLoaded(isAddedToWatchList)
        ]),
        initialState: WatchlistStatusTVSeriesEmpty());

    await tester.pumpWidget(
      _makeTestableWidget(TVSeriesDetailPage(id: idTVSeries)),
    );
    await tester.pump(Duration.zero);

    expect(find.text(tvseriesDetail.overview), findsOneWidget);
    expect(find.text(tvseriesDetail.title), findsOneWidget);
    final image = find.byType(CachedNetworkImage).evaluate().single.widget
    as CachedNetworkImage;

    expect(image.imageUrl, imageUrl);
  });

  testWidgets('should show ditonton error widget when failure',
          (tester) async {
        whenListen(
            tvseriesDetailBloc,
            Stream.fromIterable([
              TVSeriesDetailLoading(),
              TVSeriesDetailError('Server Failure')
            ]),
            initialState: TVSeriesDetailEmpty());
        whenListen(
            watchlistStatusTVSeriesBloc,
            Stream.fromIterable([
              WatchlistStatusTVSeriesLoading(),
              WatchlistStatusTVSeriesLoaded(isAddedToWatchList)
            ]),
            initialState: WatchlistStatusTVSeriesEmpty());

        await tester.pumpWidget(
          _makeTestableWidget(TVSeriesDetailPage(id: idTVSeries)),
        );
        await tester.pump(Duration.zero);
      });
}