import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/movie/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/movie/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/movie/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';

part 'movie_list_event.dart';
part 'movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;

  MovieListBloc(
      {required this.getNowPlayingMovies,
      required this.getPopularMovies,
      required this.getTopRatedMovies})
      : super(MovieListInitial()) {
    on<FetchMovieListEvent>((event, emit) async {
      if (state is MovieListInitial) {
        List<Movie> _nowPlaying = [];
        List<Movie> _popular = [];
        List<Movie> _topRated = [];

        emit(MovieListLoading());

        final nowPlayingResult = await getNowPlayingMovies.execute();
        final popularResult = await getPopularMovies.execute();
        final topRatedResult = await getTopRatedMovies.execute();

        nowPlayingResult.fold((e) => emit(LoadMovieListFailure(e.message)),
            (r) => _nowPlaying = r);
        popularResult.fold(
            (e) => emit(LoadMovieListFailure(e.message)), (r) => _popular = r);
        topRatedResult.fold((e) => emit(LoadMovieListFailure(e.message)), (r) {
          _topRated = r;
          emit(MovieListLoaded(
              nowPlayingMovies: _nowPlaying,
              popularMovies: _popular,
              topRatedMovies: _topRated));
        });
      }
    });
  }
}
