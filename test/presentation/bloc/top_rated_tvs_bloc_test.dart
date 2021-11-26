import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tvs.dart';
import 'package:ditonton/presentation/bloc/top_rated_tvs/top_rated_tvs_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_tvs_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTvs])
void main() {
  late MockGetTopRatedTvs mockGetTopRatedTvs;
  late TopRatedTvsBloc bloc;

  setUp(() {
    mockGetTopRatedTvs = MockGetTopRatedTvs();
    bloc = TopRatedTvsBloc(mockGetTopRatedTvs);
  });

  final tTv = Tv(
      backdropPath: 'backdropPath',
      firstAirDate: 'firstAirDate',
      genreIds: [1],
      id: 1,
      originalName: 'originalName',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      voteAverage: 1,
      voteCount: 1);

  final tTvList = <Tv>[tTv];

  blocTest<TopRatedTvsBloc, TopRatedTvsState>(
      'should emit [TopRatedTvsLoading, TopRatedTvsLoaded] when data is gotten successfully',
      build: () {
        when(mockGetTopRatedTvs.execute())
            .thenAnswer((_) async => Right(tTvList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTvsEvent()),
      expect: () => [TopRatedTvsLoading(), TopRatedTvsLoaded(tTvList)],
      verify: (bloc) {
        verify(mockGetTopRatedTvs.execute());
      });

  blocTest<TopRatedTvsBloc, TopRatedTvsState>(
      'should emit [TopRatedTvsLoading, TopRatedTvsFailuer] & change messagewhen data is gotten unsuccessfully',
      build: () {
        when(mockGetTopRatedTvs.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTvsEvent()),
      expect: () => [TopRatedTvsLoading(), TopRatedTvsFailure('Server Failure')],
      verify: (bloc) {
        verify(mockGetTopRatedTvs.execute());
      });
}
