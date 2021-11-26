part of 'tv_watchlist_bloc.dart';

abstract class TvWatchlistState extends Equatable {
  final String message;

  const TvWatchlistState({this.message = ""});

  @override
  List<Object> get props => [];
}

class TvWatchlistInitial extends TvWatchlistState {}

class TvWatchlistLoading extends TvWatchlistState {}

class TvWatchlistLoaded extends TvWatchlistState {
  final List<Tv> tvs;

  TvWatchlistLoaded(this.tvs);
  @override
  List<Object> get props => [tvs];
}

class TvWatchlistFailure extends TvWatchlistState {
  TvWatchlistFailure(String message) : super(message: message);
}
