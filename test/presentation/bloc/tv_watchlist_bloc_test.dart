import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/watchlist/get_watchlist_tvs.dart';
import 'package:ditonton/presentation/bloc/tv_watchlist/tv_watchlist_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_watchlist_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTvs])
void main() {
  late TvWatchlistBloc bloc;
  late MockGetWatchlistTvs mockGetWatchlistTvs;

  setUp(() {
    mockGetWatchlistTvs = MockGetWatchlistTvs();
    bloc = TvWatchlistBloc(mockGetWatchlistTvs);
  });

  blocTest<TvWatchlistBloc, TvWatchlistState>(
      'should emit [TvWatchlistLoading, TvWatchlistLoaded] change Tvs data when data is gotten successfully',
      build: () {
        when(mockGetWatchlistTvs.execute())
            .thenAnswer((_) async => Right([testWatchlistTv]));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTvWatchlistEvent()),
      expect: () => [
            TvWatchlistLoading(),
            TvWatchlistLoaded([testWatchlistTv]),
          ],
      verify: (bloc) {
        verify(mockGetWatchlistTvs.execute());
      });
  blocTest<TvWatchlistBloc, TvWatchlistState>(
      'should emit [TvWatchlistLoading, TvWatchlistFailure] change message when data is gotten unsuccessfully',
      build: () {
        when(mockGetWatchlistTvs.execute())
            .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTvWatchlistEvent()),
      expect: () => [
            TvWatchlistLoading(),
            TvWatchlistFailure('Database Failure'),
          ],
      verify: (bloc) {
        verify(mockGetWatchlistTvs.execute());
      });
}
