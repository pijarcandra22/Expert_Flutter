import 'package:bloc_test/bloc_test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/bloc/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';
import '../mock/mock_bloc.dart';

void main() {
  late TopRatedMovieBloc topRatedMovieBloc;

  setUp(() {
    topRatedMovieBloc = MockTopRatedMovieBloc();
  });

  setUpAll(() {
    registerFallbackValue(TopRatedMovieStateFake());
    registerFallbackValue(TopRatedMovieEventFake());
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedMovieBloc>.value(
      value: topRatedMovieBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
          (WidgetTester tester) async {
        whenListen(topRatedMovieBloc, Stream.fromIterable([TopRatedMovieLoading()]),
            initialState: TopRatedMovieEmpty());

        final progressBarFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));
        await tester.pump(Duration.zero);

        expect(centerFinder, findsOneWidget);
        expect(progressBarFinder, findsOneWidget);
      });

  testWidgets('Page should display ListView when data is loaded',
          (WidgetTester tester) async {
        final movie = testTVSeries;
        final imageUrl = '$BASE_IMAGE_URL${movie.posterPath}';

        whenListen(
            topRatedMovieBloc,
            Stream.fromIterable([
              TopRatedMovieLoading(),
              TopRatedMovieHasData([movie])
            ]),
            initialState: TopRatedMovieEmpty());

        final listViewFinder = find.byType(ListView);

        await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));
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
            topRatedMovieBloc,
            Stream.fromIterable(
                [TopRatedMovieLoading(), TopRatedMovieError(message)]),
            initialState: TopRatedMovieEmpty());

        await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));
        await tester.pump(Duration.zero);

        expect(find.text(message), findsOneWidget);
      });
}
