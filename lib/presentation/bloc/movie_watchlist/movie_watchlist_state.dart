part of 'movie_watchlist_bloc.dart';

abstract class MovieWatchlistState extends Equatable {
  final String message;

  const MovieWatchlistState({this.message = ""});

  @override
  List<Object> get props => [];
}

class MovieWatchlistInitial extends MovieWatchlistState {}

class MovieWatchlistLoading extends MovieWatchlistState {}

class MovieWatchlistLoaded extends MovieWatchlistState {
  final List<Movie> movies;

  MovieWatchlistLoaded(this.movies);
  @override
  List<Object> get props => [movies];
}

class MovieWatchlistFailure extends MovieWatchlistState {
  MovieWatchlistFailure(String message) : super(message: message);
}
