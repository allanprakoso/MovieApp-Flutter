part of 'movie_search_bloc.dart';

abstract class MovieSearchState extends Equatable {
  final String message;
  const MovieSearchState({this.message = ""});

  @override
  List<Object> get props => [message];
}

class MovieSearchInitial extends MovieSearchState {}

class MovieSearchLoading extends MovieSearchState {}

class MovieSearchLoaded extends MovieSearchState {
  final List<Movie> movies;

  MovieSearchLoaded(this.movies);
  @override
  List<Object> get props => [movies];
}

class MovieSearchFailure extends MovieSearchState {
  MovieSearchFailure(String message) : super(message: message);
}
