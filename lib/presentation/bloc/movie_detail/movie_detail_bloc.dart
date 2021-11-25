import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/movie/watchlist/get_movie_watchlist_status.dart';
import 'package:ditonton/domain/usecases/movie/watchlist/remove_movie_watchlist.dart';
import 'package:ditonton/domain/usecases/movie/watchlist/save_movie_watchlist.dart';
import 'package:equatable/equatable.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetMovieWatchListStatus getWatchListStatus;
  final SaveMovieWatchlist saveWatchlist;
  final RemoveMovieWatchlist removeWatchlist;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(MovieDetailInitial()) {
    late MovieDetail _movie;
    late List<Movie> _movieRecomendations;
    String _message = '';

    on<FetchMovieDetailEvent>((event, emit) async {
      emit(MovieDetailLoading());

      final detailResult = await getMovieDetail.execute(event.id);
      final recommendationResult =
          await getMovieRecommendations.execute(event.id);
      final watchlistStatus = await getWatchListStatus.execute(event.id);

      detailResult.fold((failure) => emit(MovieDetailFailure(failure.message)),
          (movie) {
        _movie = movie;
        recommendationResult.fold(
          (failure) => _movieRecomendations=[],
          (movies) {
            _movieRecomendations = movies;
          },
        );
        emit(MovieDetailLoaded(
            movie: _movie,
            watchlistMessage: '',
            movieRecommendations: _movieRecomendations,
            isAddedToWatchlist: watchlistStatus));
      });
    });

    on<AddWatchlistEvent>((event, emit) async {
      final result = await saveWatchlist.execute(event.movie);

      await result.fold(
        (failure) async {
          _message = failure.message;
        },
        (successMessage) async {
          _message = successMessage;
        },
      );
      
      final watchlistStatus = await getWatchListStatus.execute(event.movie.id);

      emit(MovieDetailLoaded(
          movie: _movie,
          movieRecommendations: _movieRecomendations,
          isAddedToWatchlist: watchlistStatus,
          watchlistMessage: _message));
    });

    on<RemoveMovieWatchlistEvent>((event, emit) async {
      final result = await removeWatchlist.execute(event.movie);
      
      await result.fold(
        (failure) async {
          _message = failure.message;
        },
        (successMessage) async {
          _message = successMessage;
        },
      );

      final watchlistStatus = await getWatchListStatus.execute(event.movie.id);
      emit(MovieDetailLoaded(
          movie: _movie,
          movieRecommendations: _movieRecomendations,
          isAddedToWatchlist: watchlistStatus,
          watchlistMessage: _message));
    });
  }
}
