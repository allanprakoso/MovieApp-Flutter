import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/movie/watchlist/get_movie_watchlist_status.dart';
import 'package:ditonton/domain/usecases/movie/watchlist/remove_movie_watchlist.dart';
import 'package:ditonton/domain/usecases/movie/watchlist/save_movie_watchlist.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetMovieWatchListStatus,
  SaveMovieWatchlist,
  RemoveMovieWatchlist,
])
void main() {
  late MovieDetailBloc bloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetMovieWatchListStatus mockGetMovieWatchListStatus;
  late MockSaveMovieWatchlist mockSaveMovieWatchlist;
  late MockRemoveMovieWatchlist mockRemoveMovieWatch;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetMovieWatchListStatus = MockGetMovieWatchListStatus();
    mockSaveMovieWatchlist = MockSaveMovieWatchlist();
    mockRemoveMovieWatch = MockRemoveMovieWatchlist();
    bloc = new MovieDetailBloc(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
      getWatchListStatus: mockGetMovieWatchListStatus,
      saveWatchlist: mockSaveMovieWatchlist,
      removeWatchlist: mockRemoveMovieWatch,
    );
  });
  final tId = 1;

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovies = <Movie>[tMovie];

  void _arrangeUsecase() {
    when(mockGetMovieDetail.execute(tId))
        .thenAnswer((_) async => Right(testMovieDetail));
    when(mockGetMovieRecommendations.execute(tId))
        .thenAnswer((_) async => Right(tMovies));
    when(mockGetMovieWatchListStatus.execute(tId))
        .thenAnswer((_) async => true);
  }

  blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit [MovieDetaiLoading, MovieDetailLoaded] when data movie detail is gotten successfully',
      build: () {
        _arrangeUsecase();
        return bloc;
      },
      act: (bloc) => bloc.add(FetchMovieDetailEvent(tId)),
      expect: () => [
            MovieDetailLoading(),
            MovieDetailLoaded(
                movie: testMovieDetail,
                movieRecommendations: tMovies,
                isAddedToWatchlist: true),
          ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
        verify(mockGetMovieWatchListStatus.execute(tId));
      });
  blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit [MovieDetaiLoading, MovieDetailFailure] when data movie detail is gotten unsucces',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tMovies));
        when(mockGetMovieWatchListStatus.execute(tId))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(FetchMovieDetailEvent(tId)),
      expect: () =>
          [MovieDetailLoading(), MovieDetailFailure('Server Failure')],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(tId));
      });

  blocTest<MovieDetailBloc, MovieDetailState>(
      "should update watchlist status when add watchlist success",
      build: () {
        _arrangeUsecase();
        when(mockSaveMovieWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Added to Watchlist'));
        when(mockGetMovieWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => {
            bloc.add(FetchMovieDetailEvent(tId)),
            bloc.add(AddWatchlistEvent(testMovieDetail))
          },
      expect: () => [
            MovieDetailLoading(),
            MovieDetailLoaded(
                movie: testMovieDetail,
                movieRecommendations: tMovies,
                isAddedToWatchlist: true,
                watchlistMessage: 'Added to Watchlist')
          ],
      verify: (bloc) {
        verify(mockSaveMovieWatchlist.execute(testMovieDetail));
        verify(mockGetMovieWatchListStatus.execute(testMovieDetail.id));
      });
  blocTest<MovieDetailBloc, MovieDetailState>(
      "should update watchlist status when add watchlist failed",
      build: () {
        _arrangeUsecase();
        when(mockSaveMovieWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetMovieWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return bloc;
      },
      act: (bloc) => {
            bloc.add(FetchMovieDetailEvent(tId)),
            bloc.add(AddWatchlistEvent(testMovieDetail))
          },
      expect: () => [
            MovieDetailLoading(),
            MovieDetailLoaded(
                movie: testMovieDetail,
                movieRecommendations: tMovies,
                isAddedToWatchlist: false,
                watchlistMessage: 'Failed')
          ],
      verify: (bloc) {
        verify(mockSaveMovieWatchlist.execute(testMovieDetail));
        verify(mockGetMovieWatchListStatus.execute(testMovieDetail.id));
      });
  blocTest<MovieDetailBloc, MovieDetailState>(
      "should update watchlist status when remove watchlist success",
      build: () {
        _arrangeUsecase();
        when(mockRemoveMovieWatch.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Removed'));
        when(mockGetMovieWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => {
            bloc.add(FetchMovieDetailEvent(tId)),
            bloc.add(RemoveMovieWatchlistEvent(testMovieDetail))
          },
      expect: () => [
            MovieDetailLoading(),
            MovieDetailLoaded(
                movie: testMovieDetail,
                movieRecommendations: tMovies,
                isAddedToWatchlist: true,
                watchlistMessage: 'Added to Watchlist')
          ],
      verify: (bloc) {
        verify(mockRemoveMovieWatch.execute(testMovieDetail));
        verify(mockGetMovieWatchListStatus.execute(testMovieDetail.id));
      });

  blocTest<MovieDetailBloc, MovieDetailState>(
      "should update watchlist status when remove watchlist failed",
      build: () {
        _arrangeUsecase();
        when(mockRemoveMovieWatch.execute(testMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetMovieWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => {
            bloc.add(FetchMovieDetailEvent(tId)),
            bloc.add(RemoveMovieWatchlistEvent(testMovieDetail))
          },
      expect: () => [
            MovieDetailLoading(),
            MovieDetailLoaded(
                movie: testMovieDetail,
                movieRecommendations: tMovies,
                isAddedToWatchlist: true,
                watchlistMessage: 'Failed')
          ],
      verify: (bloc) {
        verify(mockRemoveMovieWatch.execute(testMovieDetail));
        verify(mockGetMovieWatchListStatus.execute(testMovieDetail.id));
      });
}
