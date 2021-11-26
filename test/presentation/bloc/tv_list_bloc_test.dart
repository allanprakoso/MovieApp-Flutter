import 'package:dartz/dartz.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/get_now_playing_tvs.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tvs.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tvs.dart';
import 'package:ditonton/presentation/bloc/tv_list/tv_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_list_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingTvs, GetPopularTvs, GetTopRatedTvs])
void main() {
  late TvListBloc bloc;
  late MockGetNowPlayingTvs mockGetNowPlayingTvs;
  late MockGetPopularTvs mockGetPopularTvs;
  late MockGetTopRatedTvs mockGetTopRatedTvs;

  setUp(() {
    mockGetNowPlayingTvs = MockGetNowPlayingTvs();
    mockGetNowPlayingTvs = MockGetNowPlayingTvs();
    mockGetPopularTvs = MockGetPopularTvs();
    mockGetTopRatedTvs = MockGetTopRatedTvs();
    bloc = TvListBloc(
      getNowPlayingTvs: mockGetNowPlayingTvs,
      getPopularTvs: mockGetPopularTvs,
      getTopRatedTvs: mockGetTopRatedTvs,
    );
  });

  blocTest<TvListBloc, TvListState>(
      'should emit [TvListLoading, TvListLoaded] when data is gottern successfully',
      build: () {
        when(mockGetNowPlayingTvs.execute())
            .thenAnswer((_) async => Right(testTvList));
        when(mockGetPopularTvs.execute())
            .thenAnswer((_) async => Right(testTvList));
        when(mockGetTopRatedTvs.execute())
            .thenAnswer((_) async => Right(testTvList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTvListEvent()),
      expect: () => [
            TvListLoading(),
            TvListLoaded(
                nowPlayingTvs: testTvList,
                popularTvs: testTvList,
                topRatedTvs: testTvList),
          ],
      verify: (bloc) {
        verify(mockGetNowPlayingTvs.execute());
        verify(mockGetPopularTvs.execute());
        verify(mockGetTopRatedTvs.execute());
      });
  blocTest<TvListBloc, TvListState>(
      "should emit [TvListLoading, LoadTvListFailure] when get data is unsuccessful",
      build: () {
        when(mockGetNowPlayingTvs.execute())
            .thenAnswer((_) async => Right(testTvList));
        when(mockGetPopularTvs.execute())
            .thenAnswer((_) async => Right(testTvList));
        when(mockGetTopRatedTvs.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTvListEvent()),
      expect: () => [
            TvListLoading(),
            TvListFailure('Server Failure'),
          ],
      verify: (bloc) {
        verify(mockGetNowPlayingTvs.execute());
        verify(mockGetPopularTvs.execute());
        verify(mockGetTopRatedTvs.execute());
      });


}
