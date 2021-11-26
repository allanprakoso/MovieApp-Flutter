import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_recomendations.dart';
import 'package:ditonton/domain/usecases/tv/watchlist/get_tv_watchlist_status.dart';
import 'package:ditonton/domain/usecases/tv/watchlist/remove_tv_watchlist.dart';
import 'package:ditonton/domain/usecases/tv/watchlist/save_tv_watchlist.dart';
import 'package:equatable/equatable.dart';

part 'tv_detail_event.dart';
part 'tv_detail_state.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;
  final GetTvWatchListStatus getWatchListStatus;
  final SaveTvWatchlist saveWatchlist;
  final RemoveTvWatchlist removeWatchlist;

  TvDetailBloc(
      {required this.getTvDetail,
      required this.getTvRecommendations,
      required this.getWatchListStatus,
      required this.saveWatchlist,
      required this.removeWatchlist})
      : super(TvDetailInitial()) {
    late TvDetail _tv;
    late List<Tv> _tvRecomendations;
    String _message = '';

    on<FetchTvDetailEvent>((event, emit) async {
      emit(TvDetailLoading());

      final detailResult = await getTvDetail.execute(event.id);
      final recommendationResult =
          await getTvRecommendations.execute(event.id);
      final watchlistStatus = await getWatchListStatus.execute(event.id);

      detailResult.fold((failure) => emit(TvDetailFailure(failure.message)),
          (tv) {
        _tv = tv;
        recommendationResult.fold(
          (failure) => _tvRecomendations = [],
          (tvs) {
            _tvRecomendations = tvs;
          },
        );
        emit(TvDetailLoaded(
            tvDetail: _tv,
            watchlistMessage: '',
            tvRecommendations: _tvRecomendations,
            isAddedToWatchlist: watchlistStatus));
      });
    });

    on<AddWatchlistEvent>((event, emit) async {
      final result = await saveWatchlist.execute(event.tvDetail);

      await result.fold(
        (failure) async {
          _message = failure.message;
        },
        (successMessage) async {
          _message = successMessage;
        },
      );

      final watchlistStatus = await getWatchListStatus.execute(event.tvDetail.id);

      emit(TvDetailLoaded(
          tvDetail: _tv,
          tvRecommendations: _tvRecomendations,
          isAddedToWatchlist: watchlistStatus,
          watchlistMessage: _message));
    });

    on<RemoveTvWatchlistEvent>((event, emit) async {
      final result = await removeWatchlist.execute(event.tvDetail);

      await result.fold(
        (failure) async {
          _message = failure.message;
        },
        (successMessage) async {
          _message = successMessage;
        },
      );

      final watchlistStatus = await getWatchListStatus.execute(event.tvDetail.id);
      emit(TvDetailLoaded(
          tvDetail: _tv,
          tvRecommendations: _tvRecomendations,
          isAddedToWatchlist: watchlistStatus,
          watchlistMessage: _message));
    });
  }
}
