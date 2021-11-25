part of 'movie_detail_bloc.dart';

abstract class MovieDetailState extends Equatable {
  final bool isAddedToWatchlist;
  final String watchlistMessage;
  const MovieDetailState(
      {this.isAddedToWatchlist = false, this.watchlistMessage = ''});

  @override
  List<Object> get props => [];
}

class MovieDetailInitial extends MovieDetailState {}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailLoaded extends MovieDetailState {
  final MovieDetail movie;
  final List<Movie> movieRecommendations;
  

  MovieDetailLoaded({
    required this.movie,
    required this.movieRecommendations,
    required bool isAddedToWatchlist,
    String watchlistMessage='',
  }) : super(isAddedToWatchlist: isAddedToWatchlist, watchlistMessage: watchlistMessage);

  @override
  List<Object> get props => [movie, isAddedToWatchlist, movieRecommendations];
}

class MovieDetailFailure extends MovieDetailState {
  final String message;

  MovieDetailFailure(this.message);

  @override
  List<Object> get props => [message];
}
