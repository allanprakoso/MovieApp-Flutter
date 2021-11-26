part of 'tv_detail_bloc.dart';

abstract class TvDetailEvent extends Equatable {
  const TvDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchTvDetailEvent extends TvDetailEvent {
  final int id;

  FetchTvDetailEvent(this.id);

  @override
  List<Object> get props => [id];
}

class AddWatchlistEvent extends TvDetailEvent {
  final TvDetail tvDetail;
  AddWatchlistEvent(this.tvDetail);
}

class RemoveTvWatchlistEvent extends TvDetailEvent {
  final TvDetail tvDetail;
  RemoveTvWatchlistEvent(this.tvDetail);
}
