import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_now_playing_tvs.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tvs.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tvs.dart';
import 'package:equatable/equatable.dart';

part 'tv_list_event.dart';
part 'tv_list_state.dart';

class TvListBloc extends Bloc<TvListEvent, TvListState> {
  final GetNowPlayingTvs getNowPlayingTvs;
  final GetPopularTvs getPopularTvs;
  final GetTopRatedTvs getTopRatedTvs;

  TvListBloc(
      {required this.getNowPlayingTvs,
      required this.getPopularTvs,
      required this.getTopRatedTvs})
      : super(TvListInitial()) {
    on<FetchTvListEvent>((event, emit) async {
      List<Tv> _nowPlaying = [];
      List<Tv> _popular = [];
      List<Tv> _topRated = [];

      emit(TvListLoading());
      final nowPlayingTvs = await getNowPlayingTvs.execute();
      final popularTvs = await getPopularTvs.execute();
      final topRatedTvs = await getTopRatedTvs.execute();

      nowPlayingTvs.fold((l) => emit(TvListFailure(l.message)), (nowPlaying) {
        _nowPlaying = nowPlaying;
        popularTvs.fold((l) => emit(TvListFailure(l.message)), (popular) {
          _popular = popular;
          topRatedTvs.fold((l) => emit(TvListFailure(l.message)), (topRated) {
            _topRated = topRated;
            emit(TvListLoaded(
              nowPlayingTvs: _nowPlaying,
              popularTvs: _popular,
              topRatedTvs: _topRated,
            ));
          });
        });
      });
    });
  }
}
