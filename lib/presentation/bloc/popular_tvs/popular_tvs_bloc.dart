import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tvs.dart';
import 'package:equatable/equatable.dart';

part 'popular_tvs_event.dart';
part 'popular_tvs_state.dart';

class PopularTvsBloc extends Bloc<PopularTvsEvent, PopularTvsState> {
  final GetPopularTvs getPopularTvs;
  PopularTvsBloc(this.getPopularTvs) : super(PopularTvsInitial()) {
    on<FetchPopularTvsEvent>((event, emit) async {
      emit(PopularTvsLoading());
      final result = await getPopularTvs.execute();

      result.fold((failure) => emit(PopularTvsFailure(failure.message)),
          (tvs) => emit(PopularTvsLoaded(tvs)));
    });
  }
}
