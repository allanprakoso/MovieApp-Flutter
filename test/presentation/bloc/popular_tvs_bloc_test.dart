import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tvs.dart';
import 'package:ditonton/presentation/bloc/popular_tvs/popular_tvs_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_tvs_bloc_test.mocks.dart';


@GenerateMocks([GetPopularTvs])
void main() {
  late MockGetPopularTvs mockGetPopularTvs;
  late PopularTvsBloc bloc;

  setUp(() {
    mockGetPopularTvs = MockGetPopularTvs();
    bloc = PopularTvsBloc(mockGetPopularTvs);
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

  blocTest<PopularTvsBloc, PopularTvsState>(
    'should emit [PopularTvsLoading, PopularTvsLoaded] when data is gotten successfully',
    build: () {
      when(mockGetPopularTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchPopularTvsEvent()),
    expect: () => [PopularTvsLoading(), PopularTvsLoaded(tTvList)],
    verify: (bloc) {
      verify(mockGetPopularTvs.execute());
    },
  );

  blocTest<PopularTvsBloc, PopularTvsState>(
    'should emit [PopularTvsLoading, PopularTvsFailure] & change message when data is gotten unsuccessfully',
    build: () {
      when(mockGetPopularTvs.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchPopularTvsEvent()),
    expect: () =>
        [PopularTvsLoading(), PopularTvsFailure('Server Failure')],
    verify: (bloc) {
      verify(mockGetPopularTvs.execute());
    },
  );
}
