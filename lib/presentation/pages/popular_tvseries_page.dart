import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/tvseries_popular/tvseries_popular_bloc.dart';
import 'package:ditonton/presentation/provider/popular_tvseries_notifier.dart';
import 'package:ditonton/presentation/widgets/tvseries_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class PopularTVSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-tv-series';

  @override
  _PopularTVSeriesPageState createState() => _PopularTVSeriesPageState();
}

class _PopularTVSeriesPageState extends State<PopularTVSeriesPage> {
  @override
  void initState() {
    super.initState();
    context.read<PopularTVSeriesBloc>().add(OnPopularTVSeriesDataRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularTVSeriesBloc, PopularTVSeriesState>(
          builder: (context, state) {
            if (state is PopularTVSeriesLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PopularTVSeriesHasData) {
              final data = state;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = data.movies[index];
                  return TVSeriesCard(movie);
                },
                itemCount: data.movies.length,
              );
            } else if (state is PopularTVSeriesError) {
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
