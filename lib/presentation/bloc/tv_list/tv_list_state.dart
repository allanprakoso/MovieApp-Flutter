part of 'tv_list_bloc.dart';

abstract class TvListState extends Equatable {
  final String message;
  const TvListState({this.message = ""});

  @override
  List<Object> get props => [];
}

class TvListInitial extends TvListState {}

class TvListLoading extends TvListState {}

class TvListLoaded extends TvListState {
  final List<Tv> nowPlayingTvs;
  final List<Tv> popularTvs;
  final List<Tv> topRatedTvs;

  TvListLoaded(
      {required this.nowPlayingTvs,
      required this.popularTvs,
      required this.topRatedTvs});

  @override
  List<Object> get props => [nowPlayingTvs, popularTvs, topRatedTvs];
}

class TvListFailure extends TvListState {
  TvListFailure(String message) : super(message: message);
}
