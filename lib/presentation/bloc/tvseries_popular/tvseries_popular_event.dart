part of 'tvseries_popular_bloc.dart';

abstract class PopularTVSeriesEvent extends Equatable {
  const PopularTVSeriesEvent();

  @override
  List<Object> get props => [];
}

class OnPopularTVSeriesDataRequested extends PopularTVSeriesEvent {}