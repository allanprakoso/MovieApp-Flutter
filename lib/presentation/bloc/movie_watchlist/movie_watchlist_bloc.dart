import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/movie/watchlist/get_watchlist_movies.dart';
import 'package:equatable/equatable.dart';

part 'movie_watchlist_event.dart';
part 'movie_watchlist_state.dart';

class MovieWatchlistBloc
    extends Bloc<MovieWatchlistEvent, MovieWatchlistState> {
  final GetWatchlistMovies getWatchlistMovies;
  MovieWatchlistBloc(this.getWatchlistMovies) : super(MovieWatchlistInitial()) {
    on<FetchMovieWatchlistEvent>((event, emit) async {
      emit(MovieWatchlistLoading());
      final result = await getWatchlistMovies.execute();

      result.fold(
        (l) => emit(
          MovieWatchlistFailure(l.message),
        ),
        (r) => emit(
          MovieWatchlistLoaded(r),
        ),
      );
    });
  }
}
