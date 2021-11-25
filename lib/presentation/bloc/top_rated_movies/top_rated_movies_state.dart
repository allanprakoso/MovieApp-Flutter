part of 'top_rated_movies_bloc.dart';

abstract class TopRatedMoviesState extends Equatable {
  final String message;
  const TopRatedMoviesState({this.message='error'});

  @override
  List<Object> get props => [message];
}

class TopRatedMoviesInitial extends TopRatedMoviesState {}

class TopRatedMoviesLoading extends TopRatedMoviesState {}

class TopRatedMoviesLoaded extends TopRatedMoviesState {
  final List<Movie> movies;

  TopRatedMoviesLoaded(this.movies);

  @override
  List<Object> get props => [movies];
}

class TopRatedMoviesFailure extends TopRatedMoviesState {
  TopRatedMoviesFailure(String message): super(message: message);
}
