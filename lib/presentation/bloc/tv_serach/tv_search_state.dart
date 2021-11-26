part of 'tv_search_bloc.dart';

abstract class TvSearchState extends Equatable {
  final String message;
  const TvSearchState({this.message = ""});

  @override
  List<Object> get props => [message];
}

class TvSearchInitial extends TvSearchState {}

class TvSearchLoading extends TvSearchState {}

class TvSearchLoaded extends TvSearchState {
  final List<Tv> tvs;

  TvSearchLoaded(this.tvs);
  @override
  List<Object> get props => [tvs];
}

class TvSearchFailure extends TvSearchState {
  TvSearchFailure(String message) : super(message: message);
}
