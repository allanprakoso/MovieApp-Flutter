import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:equatable/equatable.dart';

class TvDetail extends Equatable {
    final String? backdropPath;
  final String firstAirDate;
  final List<Genre> genres;
  final int id;
  final bool inProduction;
  final String lastAirDate;
  final String name;
  final int numberOfSeasons;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final double popularity;
  final String posterPath;
  final List<Season> seasons;
  final String status;
  final String type;
  final double voteAverage;
  final int voteCount;

  TvDetail(
      {required this.backdropPath,
      required this.firstAirDate,
      required this.genres,
      required this.id,
      required this.inProduction,
      required this.lastAirDate,
      required this.name,
      required this.numberOfSeasons,
      required this.originalLanguage,
      required this.originalName,
      required this.overview,
      required this.popularity,
      required this.posterPath,
      required this.seasons,
      required this.status,
      required this.type,
      required this.voteAverage,
      required this.voteCount});

  @override
  List<Object?> get props => [
        backdropPath,
        firstAirDate,
        genres,
        id,
        inProduction,
        lastAirDate,
        name,
        numberOfSeasons,
        originalLanguage,
        originalName,
        overview,
        popularity,
        posterPath,
        seasons,
        status,
        type,
        voteAverage,
        voteCount
      ];

}