import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/season_model.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:equatable/equatable.dart';

class TvDetailResponse extends Equatable {
  final String? backdropPath;
  final String firstAirDate;
  final List<GenreModel> genres;
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
  final List<SeasonModel> seasons;
  final String status;
  final String type;
  final double voteAverage;
  final int voteCount;

  TvDetailResponse(
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

  factory TvDetailResponse.fromJson(Map<String, dynamic> json) =>
      TvDetailResponse(
          backdropPath: json['backdrop_path'],
          firstAirDate: json['first_air_date'],
          genres: List<GenreModel>.from(
              json["genres"].map((x) => GenreModel.fromJson(x))),
          id: json['id'],
          inProduction: json['in_production'],
          lastAirDate: json['last_air_date'],
          name: json['name'],
          numberOfSeasons: json['number_of_seasons'],
          originalLanguage: json['original_language'],
          originalName: json['original_name'],
          overview: json['overview'],
          popularity: json['popularity'],
          posterPath: json['poster_path'],
          status: json['status'],
          seasons: List<SeasonModel>.from(
              json['seasons'].map((x) => SeasonModel.fromJson(x))),
          type: json['type'],
          voteAverage: json['vote_average'],
          voteCount: json['vote_count']);

  Map<String, dynamic> toJson() => {
        "backdrop_path": backdropPath,
        "first_air_date": firstAirDate,
        "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
        "id": id,
        "in_production": inProduction,
        "last_air_date": lastAirDate,
        "name": name,
        "number_of_seasons": numberOfSeasons,
        "original_language": originalLanguage,
        "original_name": originalName,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "seasons": List<dynamic>.from(seasons.map((x) => x.toJson())),
        "status": status,
        "type": type,
        "vote_average": voteAverage,
        "vote_count": voteCount
      };

  TvDetail toEntity() => TvDetail(
      backdropPath: this.backdropPath,
      firstAirDate: this.firstAirDate,
      genres: this.genres.map((genre) => genre.toEntity()).toList(),
      id: this.id,
      inProduction: this.inProduction,
      lastAirDate: this.lastAirDate,
      name: this.name,
      numberOfSeasons: this.numberOfSeasons,
      originalLanguage: this.originalLanguage,
      originalName: this.originalName,
      overview: this.overview,
      popularity: this.popularity,
      posterPath: this.posterPath,
      seasons: this.seasons.map((season) => season.toEntity()).toList(),
      status: this.status,
      type: this.type,
      voteAverage: this.voteAverage,
      voteCount: this.voteCount);

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
