import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/movie/watchlist/get_watchlist_movies.dart';
import 'package:ditonton/presentation/bloc/movie_watchlist/movie_watchlist_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_watchlist_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late MovieWatchlistBloc bloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    bloc = MovieWatchlistBloc(mockGetWatchlistMovies);
  });

  blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      'should emit [MovieWatchlistLoading, MovieWatchlistLoaded] change movies data when data is gotten successfully',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Right([testWatchlistMovie]));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchMovieWatchlistEvent()),
      expect: () => [
            MovieWatchlistLoading(),
            MovieWatchlistLoaded([testWatchlistMovie]),
          ],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
      });
  blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      'should emit [MovieWatchlistLoading, MovieWatchlistFailure] change message when data is gotten unsuccessfully',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchMovieWatchlistEvent()),
      expect: () => [
            MovieWatchlistLoading(),
            MovieWatchlistFailure('Database Failure'),
          ],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
      });
}
