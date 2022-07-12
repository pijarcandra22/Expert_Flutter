import 'package:bloc_test/bloc_test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/bloc/top_rated_tvseries/top_rated_tvseries_bloc.dart';
import 'package:ditonton/presentation/pages/top_rated_tvseries_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';
import '../mock/mock_bloc.dart';

void main() {
  late TopRatedTVSeriesBloc topRatedTVSeriesBloc;

  setUp(() {
    topRatedTVSeriesBloc = MockTopRatedTVSeriesBloc();
  });

  setUpAll(() {
    registerFallbackValue(TopRatedTVSeriesStateFake());
    registerFallbackValue(TopRatedTVSeriesEventFake());
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTVSeriesBloc>.value(
      value: topRatedTVSeriesBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
          (WidgetTester tester) async {
        whenListen(topRatedTVSeriesBloc, Stream.fromIterable([TopRatedTVSeriesLoading()]),
            initialState: TopRatedTVSeriesEmpty());

        final progressBarFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(TopRatedTVSeriesPage()));
        await tester.pump(Duration.zero);

        expect(centerFinder, findsOneWidget);
        expect(progressBarFinder, findsOneWidget);
      });

  testWidgets('Page should display ListView when data is loaded',
          (WidgetTester tester) async {
        final movie = testTVSeries;
        final imageUrl = '$BASE_IMAGE_URL${movie.posterPath}';

        whenListen(
            topRatedTVSeriesBloc,
            Stream.fromIterable([
              TopRatedTVSeriesLoading(),
              TopRatedTVSeriesHasData([movie])
            ]),
            initialState: TopRatedTVSeriesEmpty());

        final listViewFinder = find.byType(ListView);

        await tester.pumpWidget(_makeTestableWidget(TopRatedTVSeriesPage()));
        await tester.pump(Duration.zero);

        expect(listViewFinder, findsOneWidget);

        expect(find.text(movie.overview.toString()), findsOneWidget);
        expect(find.text(movie.title.toString()), findsOneWidget);
        final image = find.byType(CachedNetworkImage).evaluate().single.widget
        as CachedNetworkImage;

        expect(image.imageUrl, imageUrl);
      });

  testWidgets('Page should display text with message when Error',
          (WidgetTester tester) async {
        final message = 'Server Failure';

        whenListen(
            topRatedTVSeriesBloc,
            Stream.fromIterable(
                [TopRatedTVSeriesLoading(), TopRatedTVSeriesError(message)]),
            initialState: TopRatedTVSeriesEmpty());

        await tester.pumpWidget(_makeTestableWidget(TopRatedTVSeriesPage()));
        await tester.pump(Duration.zero);

        expect(find.text(message), findsOneWidget);
      });
}
