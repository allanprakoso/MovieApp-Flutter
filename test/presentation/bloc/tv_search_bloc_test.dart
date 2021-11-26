import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/search_tvs.dart';
import 'package:ditonton/presentation/bloc/tv_serach/tv_search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_search_bloc_test.mocks.dart';


@GenerateMocks([SearchTvs])
void main() {
  late TvSearchBloc bloc;
  late MockSearchTvs mockSearchTvs;

  setUp(() {
    mockSearchTvs = MockSearchTvs();
    bloc = TvSearchBloc(mockSearchTvs);
  });

  final tTvModel =  Tv(
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
  final tTvList = <Tv>[tTvModel];
  final tQuery = 'spiderman';

  blocTest<TvSearchBloc, TvSearchState>(
      'should emit [TvSearchLoading, TvSearchLoaded] when data is gottern successfully',
      build: () {
        when(mockSearchTvs.execute(tQuery))
            .thenAnswer((_) async => Right(tTvList));
        return bloc;
      },
      act: (bloc) => bloc.add(SearchTvsEvent(tQuery)),
      expect: () => [TvSearchLoading(), TvSearchLoaded(tTvList)],
      verify: (bloc) {
        verify(mockSearchTvs.execute(tQuery));
      });

  blocTest<TvSearchBloc, TvSearchState>(
      'should emit [TvSearchLoading, TvSearchFailure] when data is gottern unsuccessfully',
      build: () {
        when(mockSearchTvs.execute(tQuery))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(SearchTvsEvent(tQuery)),
      expect: () =>
          [TvSearchLoading(), TvSearchFailure('Server Failure')],
      verify: (bloc) {
        verify(mockSearchTvs.execute(tQuery));
      });
}
