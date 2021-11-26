part of 'tv_search_bloc.dart';

abstract class TvSearchEvent extends Equatable {
  final String query;
  const TvSearchEvent(this.query);

  @override
  List<Object> get props => [query];
}

class SearchTvsEvent extends TvSearchEvent {
  SearchTvsEvent(String query) : super(query);
}