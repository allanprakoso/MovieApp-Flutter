import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/search_tvs.dart';
import 'package:equatable/equatable.dart';

part 'tv_search_event.dart';
part 'tv_search_state.dart';

class TvSearchBloc extends Bloc<TvSearchEvent, TvSearchState> {
  final SearchTvs searchTvs;
  TvSearchBloc(this.searchTvs) : super(TvSearchInitial()) {
    on<SearchTvsEvent>((event, emit) async {
      emit(TvSearchLoading());
      final result = await searchTvs.execute(event.query);

      result.fold(
          (failure) => emit(
                TvSearchFailure(failure.message),
              ),
          (tvs) => emit(
                TvSearchLoaded(tvs),
              ));
    });
  }
}
