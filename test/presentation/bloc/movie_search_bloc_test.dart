import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/movie/search_movies.dart';
import 'package:ditonton/presentation/bloc/movie_serach/movie_search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../provider/movie/movie_search_notifier_test.mocks.dart';

@GenerateMocks([SearchMovies])
void main() {
  late MovieSearchBloc bloc;
  late MockSearchMovies mockSearchMovies;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    bloc = MovieSearchBloc(mockSearchMovies);
  });

  final tMovieModel = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tMovieList = <Movie>[tMovieModel];
  final tQuery = 'spiderman';

  blocTest<MovieSearchBloc, MovieSearchState>(
      'should emit [MovieSearchLoading, MovieSearchLoaded] when data is gottern successfully',
      build: () {
        when(mockSearchMovies.execute(tQuery))
            .thenAnswer((_) async => Right(tMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(SearchMoviesEvent(tQuery)),
      expect: () => [MovieSearchLoading(), MovieSearchLoaded(tMovieList)],
      verify: (bloc) {
        verify(mockSearchMovies.execute(tQuery));
      });

  blocTest<MovieSearchBloc, MovieSearchState>(
      'should emit [MovieSearchLoading, MovieSearchFailure] when data is gottern unsuccessfully',
      build: () {
        when(mockSearchMovies.execute(tQuery))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(SearchMoviesEvent(tQuery)),
      expect: () =>
          [MovieSearchLoading(), MovieSearchFailure('Server Failure')],
      verify: (bloc) {
        verify(mockSearchMovies.execute(tQuery));
      });
}
