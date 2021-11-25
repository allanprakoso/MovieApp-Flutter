import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/movie/search_movies.dart';
import 'package:equatable/equatable.dart';

part 'movie_search_event.dart';
part 'movie_search_state.dart';

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final SearchMovies searchMovies;
  MovieSearchBloc(this.searchMovies) : super(MovieSearchInitial()) {
    on<SearchMoviesEvent>((event, emit) async {
      emit(MovieSearchLoading());
      final result = await searchMovies.execute(event.query);

      result.fold(
          (failure) => emit(
                MovieSearchFailure(failure.message),
              ),
          (movies) => emit(
                MovieSearchLoaded(movies),
              ));
    });
  }
}
