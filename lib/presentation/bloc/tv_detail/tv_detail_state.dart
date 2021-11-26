part of 'tv_detail_bloc.dart';

abstract class TvDetailState extends Equatable {
  final String message;
  final bool isAddedToWatchlist;
  final String watchlistMessage;
  const TvDetailState(
      {this.isAddedToWatchlist = false,
      this.watchlistMessage = '',
      this.message = ""});

  @override
  List<Object> get props => [];
}

class TvDetailInitial extends TvDetailState {}

class TvDetailLoading extends TvDetailState {}

class TvDetailLoaded extends TvDetailState {
  final TvDetail tvDetail;
  final List<Tv> tvRecommendations;

  TvDetailLoaded(
      {required this.tvRecommendations,
      required this.tvDetail,
      required bool isAddedToWatchlist,
      String watchlistMessage=''})
      : super(
            isAddedToWatchlist: isAddedToWatchlist,
            watchlistMessage: watchlistMessage);

  @override
  List<Object> get props => [tvDetail, isAddedToWatchlist];
}

class TvDetailFailure extends TvDetailState {
  TvDetailFailure(String message) : super(message: message);
}
