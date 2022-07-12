import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/top_rated_tvseries/top_rated_tvseries_bloc.dart';
import 'package:ditonton/presentation/provider/top_rated_tvseries_notifier.dart';
import 'package:ditonton/presentation/widgets/tvseries_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class TopRatedTVSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-tv-series';

  @override
  _TopRatedTVSeriesPageState createState() => _TopRatedTVSeriesPageState();
}

class _TopRatedTVSeriesPageState extends State<TopRatedTVSeriesPage> {
  @override
  void initState() {
    super.initState();
    context.read<TopRatedTVSeriesBloc>().add(OnTopRatedTVSeriesDataRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTVSeriesBloc, TopRatedTVSeriesState>(
          builder: (context, state) {
            if (state is TopRatedTVSeriesLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TopRatedTVSeriesHasData) {
              final data = state;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = data.movies[index];
                  return TVSeriesCard(movie);
                },
                itemCount: data.movies.length,
              );
            } else if (state is TopRatedTVSeriesError) {
              return Center(
                child: Text(state.message),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
