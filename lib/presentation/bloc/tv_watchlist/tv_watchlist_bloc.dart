import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/watchlist/get_watchlist_tvs.dart';
import 'package:equatable/equatable.dart';

part 'tv_watchlist_event.dart';
part 'tv_watchlist_state.dart';

class TvWatchlistBloc extends Bloc<TvWatchlistEvent, TvWatchlistState> {
  final GetWatchlistTvs getWatchlistTvs;
  TvWatchlistBloc(this.getWatchlistTvs) : super(TvWatchlistInitial()) {
    on<FetchTvWatchlistEvent>((event, emit) async {
      emit(TvWatchlistLoading());
      final result = await getWatchlistTvs.execute();
      result.fold(
        (l) => emit(
          TvWatchlistFailure(l.message),
        ),
        (r) => emit(
          TvWatchlistLoaded(r),
        ),
      );
    });
  }
}
