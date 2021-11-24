import 'dart:convert';

import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tTvModel = TvModel(
      backdropPath: "/oC9SgtJTDCEpWnTBtVGoAvjl5hb.jpg",
      firstAirDate: "2006-09-18",
      genreIds: [10767],
      id: 1991,
      originalName: "Rachael Ray",
      overview: "Rachael Ray",
      popularity: 3147.117,
      posterPath: "/dsAJhCLYX1fiNRoiiJqR6Up4aJ.jpg",
      voteAverage: 5.7,
      voteCount: 30);
  final tTvResponseModel = TvResponse(tvList: <TvModel>[tTvModel]);
  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/now_playing_tv.json'));
      // act
      final result = TvResponse.fromJson(jsonMap);
      // assert
      expect(result, tTvResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tTvResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "backdrop_path": "/oC9SgtJTDCEpWnTBtVGoAvjl5hb.jpg",
            "first_air_date": "2006-09-18",
            "genre_ids": [10767],
            "id": 1991,
            "original_name": "Rachael Ray",
            "overview": "Rachael Ray",
            "popularity": 3147.117,
            "poster_path": "/dsAJhCLYX1fiNRoiiJqR6Up4aJ.jpg",
            "vote_average": 5.7,
            "vote_count": 30
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
