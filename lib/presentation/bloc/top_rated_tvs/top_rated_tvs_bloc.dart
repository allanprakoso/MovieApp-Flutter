import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tvs.dart';
import 'package:equatable/equatable.dart';

part 'top_rated_tvs_event.dart';
part 'top_rated_tvs_state.dart';

class TopRatedTvsBloc
    extends Bloc<TopRatedTvsEvent, TopRatedTvsState> {
  final GetTopRatedTvs getTopRatedTvs;
  TopRatedTvsBloc(this.getTopRatedTvs) : super(TopRatedTvsInitial()) {
    on<FetchTopRatedTvsEvent>((event, emit) async {
      emit(TopRatedTvsLoading());
      final result = await getTopRatedTvs.execute();

      result.fold(
        (l) => emit(TopRatedTvsFailure(l.message)),
        (r) => emit(TopRatedTvsLoaded(r)),
      );
    });
  }
}
