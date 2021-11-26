part of 'popular_tvs_bloc.dart';

abstract class PopularTvsState extends Equatable {
  final String message;
  const PopularTvsState({this.message = 'error'});

  @override
  List<Object> get props => [];
}

class PopularTvsInitial extends PopularTvsState {}

class PopularTvsLoading extends PopularTvsState {}

class PopularTvsLoaded extends PopularTvsState {
  final List<Tv> tvs;

  PopularTvsLoaded(this.tvs);

  @override
  List<Object> get props => [tvs];
}

class PopularTvsFailure extends PopularTvsState {
  PopularTvsFailure(String message) : super(message: message);

  @override
  List<Object> get props => [message];
}
