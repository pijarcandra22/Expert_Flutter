import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tvseries_detail.dart';
import 'package:ditonton/presentation/bloc/tvseries_detail/tvseries_detail_bloc.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class TVSeriesDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail-tvseries';

  final int id;
  TVSeriesDetailPage({required this.id});

  @override
  _TVSeriesDetailPageState createState() => _TVSeriesDetailPageState();
}

class _TVSeriesDetailPageState extends State<TVSeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<TVSeriesDetailBloc>().add(TVSeriesDetailData(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TVSeriesDetailBloc, TVSeriesDetailState>(
        builder: (context, state) {
          if (state is TVSeriesDetailLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TVSeriesDetailHasData) {
            final movie = state.result;
            final recomend = state.recommendations;
            return SafeArea(
              child: DetailContent(
                movie,
                recomend,
              ),
            );
          } else if (state is TVSeriesDetailError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TVSeriesDetail tvseries;
  final List<Movie> recommendations;

  DetailContent(this.tvseries, this.recommendations);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tvseries.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tvseries.title,
                              style: kHeading5,
                            ),
                            WatchlistButton(tvseries),
                            Text(
                              _showGenres(tvseries.genres),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tvseries.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tvseries.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tvseries.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            Container(
                              height: 150,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final movie = recommendations[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pushReplacementNamed(
                                          context,
                                          TVSeriesDetailPage.ROUTE_NAME,
                                          arguments: movie.id,
                                        );
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                          'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                          placeholder: (context, url) =>
                                              Center(
                                                child:
                                                CircularProgressIndicator(),
                                              ),
                                          errorWidget:
                                              (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: recommendations.length,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }
}

class WatchlistButton extends StatelessWidget {
  final TVSeriesDetail movie;

  WatchlistButton(this.movie);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WatchlistStatusTVSeriesBloc, WatchlistStatusTVSeriesState>(
      listener: (context, state) {
        if (state is WatchlistStatusTVSeriesSuccess) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is WatchlistStatusTVSeriesError) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                    content: Text(
                      state.message,
                    ));
              });
        }
      },
      builder: (BuildContext context, state) {
        context
            .read<WatchlistStatusTVSeriesBloc>()
            .add(OnWatchlistStatusChecked(movie.id));

        return ElevatedButton(
          onPressed: () async {
            if (state is WatchlistStatusTVSeriesLoaded) {
              context.read<WatchlistStatusTVSeriesBloc>().add(state.isAdded
                  ? OnWatchlistRemoved(movie)
                  : OnWatchlistAdded(movie));
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (state is WatchlistStatusTVSeriesLoaded)
                state.isAdded ? Icon(Icons.check) : Icon(Icons.add),
              Text('Watchlist'),
            ],
          ),
        );
      },
    );
  }
}