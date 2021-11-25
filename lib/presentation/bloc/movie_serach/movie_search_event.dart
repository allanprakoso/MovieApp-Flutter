part of 'movie_search_bloc.dart';

abstract class MovieSearchEvent extends Equatable {
  final String query;
  const MovieSearchEvent(this.query);

  @override
  List<Object> get props => [query];
}

class SearchMoviesEvent extends MovieSearchEvent {
  SearchMoviesEvent(String query) : super(query);
}