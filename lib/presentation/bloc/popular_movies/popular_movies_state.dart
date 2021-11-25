part of 'popular_movies_bloc.dart';

abstract class PopularMoviesState extends Equatable {
  final String message;
  const PopularMoviesState({this.message = 'error'});

  @override
  List<Object> get props => [];
}

class PopularMoviesInitial extends PopularMoviesState {}

class PopularMoviesLoading extends PopularMoviesState {}

class PopularMoviesLoaded extends PopularMoviesState {
  final List<Movie> movies;

  PopularMoviesLoaded(this.movies);

  @override
  List<Object> get props => [movies];
}

class PopularMoviesFailure extends PopularMoviesState {
  PopularMoviesFailure(String message) : super(message: message);

  @override
  List<Object> get props => [message];
}
