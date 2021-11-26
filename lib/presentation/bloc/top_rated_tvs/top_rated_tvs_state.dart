part of 'top_rated_tvs_bloc.dart';

abstract class TopRatedTvsState extends Equatable {
  final String message;
  const TopRatedTvsState({this.message='error'});

  @override
  List<Object> get props => [message];
}

class TopRatedTvsInitial extends TopRatedTvsState {}

class TopRatedTvsLoading extends TopRatedTvsState {}

class TopRatedTvsLoaded extends TopRatedTvsState {
  final List<Tv> tvs;

  TopRatedTvsLoaded(this.tvs);

  @override
  List<Object> get props => [tvs];
}

class TopRatedTvsFailure extends TopRatedTvsState {
  TopRatedTvsFailure(String message): super(message: message);
}
