import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/bloc/watchlist/watchlist_bloc.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tvseries_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    context.read<WatchlistBloc>().add(OnWatchlistDataRequested());
    context.read<WatchlistTVSeriesBloc>().add(OnWatchlistDataRequestedTVSeries());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    context.read<WatchlistBloc>().add(OnWatchlistDataRequested());
    context.read<WatchlistTVSeriesBloc>().add(OnWatchlistDataRequestedTVSeries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text(
                'TV Series Watchlist',
                style: kHeading6,
              ),
              BlocBuilder<WatchlistTVSeriesBloc, WatchlistTVSeriesState>(
                builder: (context, state) {
                  if (state is WatchlistTVSeriesLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is WatchlistTVSeriesHasData) {
                    final data = state.data;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final movie = data[index];
                        return TVSeriesCard(movie);
                      },
                      itemCount: data.length,
                    );
                  } else if (state is WatchlistTVSeriesError) {
                    return Center(
                      child: Text(state.message),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
              Text(
                'Movies Watchlist',
                style: kHeading6,
              ),
              BlocBuilder<WatchlistBloc, WatchlistState>(
                builder: (context, state) {
                  if (state is WatchlistLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is WatchlistHasData) {
                    final data = state.data;
                    return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        final movie = data[index];
                        return MovieCard(movie);
                      },
                      itemCount: data.length,
                    );
                  } else if (state is WatchlistError) {
                    return Center(
                      child: Text(state.message),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
