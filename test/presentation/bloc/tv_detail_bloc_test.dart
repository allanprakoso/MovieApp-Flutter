import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_recomendations.dart';
import 'package:ditonton/domain/usecases/tv/watchlist/get_tv_watchlist_status.dart';
import 'package:ditonton/domain/usecases/tv/watchlist/remove_tv_watchlist.dart';
import 'package:ditonton/domain/usecases/tv/watchlist/save_tv_watchlist.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvDetail,
  GetTvRecommendations,
  GetTvWatchListStatus,
  SaveTvWatchlist,
  RemoveTvWatchlist,
])
void main() {
  late TvDetailBloc bloc;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;
  late MockGetTvWatchListStatus mockGetTvWatchListStatus;
  late MockSaveTvWatchlist mockSaveTvWatchlist;
  late MockRemoveTvWatchlist mockRemoveTvWatch;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendations = MockGetTvRecommendations();
    mockGetTvWatchListStatus = MockGetTvWatchListStatus();
    mockSaveTvWatchlist = MockSaveTvWatchlist();
    mockRemoveTvWatch = MockRemoveTvWatchlist();
    bloc = new TvDetailBloc(
      getTvDetail: mockGetTvDetail,
      getTvRecommendations: mockGetTvRecommendations,
      getWatchListStatus: mockGetTvWatchListStatus,
      saveWatchlist: mockSaveTvWatchlist,
      removeWatchlist: mockRemoveTvWatch,
    );
  });
  final tId = 1;

  final tTv = Tv(
      backdropPath: 'backdropPath',
      firstAirDate: 'firstAirDate',
      genreIds: [1, 2],
      id: 1,
      originalName: 'originalName',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      voteAverage: 1,
      voteCount: 1);
  final tTvs = <Tv>[tTv];

  void _arrangeUsecase() {
    when(mockGetTvDetail.execute(tId))
        .thenAnswer((_) async => Right(testTvDetail));
    when(mockGetTvRecommendations.execute(tId))
        .thenAnswer((_) async => Right(tTvs));
    when(mockGetTvWatchListStatus.execute(tId))
        .thenAnswer((_) async => true);
  }

  blocTest<TvDetailBloc, TvDetailState>(
      'should emit [TvDetaiLoading, TvDetailLoaded] when data Tv detail is gotten successfully',
      build: () {
        _arrangeUsecase();
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTvDetailEvent(tId)),
      expect: () => [
            TvDetailLoading(),
            TvDetailLoaded(
                tvDetail: testTvDetail,
                tvRecommendations: tTvs,
                isAddedToWatchlist: true),
          ],
      verify: (bloc) {
        verify(mockGetTvDetail.execute(tId));
        verify(mockGetTvRecommendations.execute(tId));
        verify(mockGetTvWatchListStatus.execute(tId));
      });
  blocTest<TvDetailBloc, TvDetailState>(
      'should emit [TvDetaiLoading, TvDetailFailure] when data Tv detail is gotten unsucces',
      build: () {
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(mockGetTvRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tTvs));
        when(mockGetTvWatchListStatus.execute(tId))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTvDetailEvent(tId)),
      expect: () =>
          [TvDetailLoading(), TvDetailFailure('Server Failure')],
      verify: (bloc) {
        verify(mockGetTvDetail.execute(tId));
      });

  blocTest<TvDetailBloc, TvDetailState>(
      "should update watchlist status when add watchlist success",
      build: () {
        _arrangeUsecase();
        when(mockSaveTvWatchlist.execute(testTvDetail))
            .thenAnswer((_) async => Right('Added to Watchlist'));
        when(mockGetTvWatchListStatus.execute(testTvDetail.id))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => {
            bloc.add(FetchTvDetailEvent(tId)),
            bloc.add(AddWatchlistEvent(testTvDetail))
          },
      expect: () => [
            TvDetailLoading(),
            TvDetailLoaded(
                tvDetail: testTvDetail,
                tvRecommendations: tTvs,
                isAddedToWatchlist: true,
                watchlistMessage: 'Added to Watchlist')
          ],
      verify: (bloc) {
        verify(mockSaveTvWatchlist.execute(testTvDetail));
        verify(mockGetTvWatchListStatus.execute(testTvDetail.id));
      });
  blocTest<TvDetailBloc, TvDetailState>(
      "should update watchlist status when add watchlist failed",
      build: () {
        _arrangeUsecase();
        when(mockSaveTvWatchlist.execute(testTvDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetTvWatchListStatus.execute(testTvDetail.id))
            .thenAnswer((_) async => false);
        return bloc;
      },
      act: (bloc) => {
            bloc.add(FetchTvDetailEvent(tId)),
            bloc.add(AddWatchlistEvent(testTvDetail))
          },
      expect: () => [
            TvDetailLoading(),
            TvDetailLoaded(
                tvDetail: testTvDetail,
                tvRecommendations: tTvs,
                isAddedToWatchlist: false,
                watchlistMessage: 'Failed')
          ],
      verify: (bloc) {
        verify(mockSaveTvWatchlist.execute(testTvDetail));
        verify(mockGetTvWatchListStatus.execute(testTvDetail.id));
      });
  blocTest<TvDetailBloc, TvDetailState>(
      "should update watchlist status when remove watchlist success",
      build: () {
        _arrangeUsecase();
        when(mockRemoveTvWatch.execute(testTvDetail))
            .thenAnswer((_) async => Right('Removed'));
        when(mockGetTvWatchListStatus.execute(testTvDetail.id))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => {
            bloc.add(FetchTvDetailEvent(tId)),
            bloc.add(RemoveTvWatchlistEvent(testTvDetail))
          },
      expect: () => [
            TvDetailLoading(),
            TvDetailLoaded(
                tvDetail: testTvDetail,
                tvRecommendations: tTvs,
                isAddedToWatchlist: true,
                watchlistMessage: 'Added to Watchlist')
          ],
      verify: (bloc) {
        verify(mockRemoveTvWatch.execute(testTvDetail));
        verify(mockGetTvWatchListStatus.execute(testTvDetail.id));
      });

  blocTest<TvDetailBloc, TvDetailState>(
      "should update watchlist status when remove watchlist failed",
      build: () {
        _arrangeUsecase();
        when(mockRemoveTvWatch.execute(testTvDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetTvWatchListStatus.execute(testTvDetail.id))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => {
            bloc.add(FetchTvDetailEvent(tId)),
            bloc.add(RemoveTvWatchlistEvent(testTvDetail))
          },
      expect: () => [
            TvDetailLoading(),
            TvDetailLoaded(
                tvDetail: testTvDetail,
                tvRecommendations: tTvs,
                isAddedToWatchlist: true,
                watchlistMessage: 'Failed')
          ],
      verify: (bloc) {
        verify(mockRemoveTvWatch.execute(testTvDetail));
        verify(mockGetTvWatchListStatus.execute(testTvDetail.id));
      });
}
