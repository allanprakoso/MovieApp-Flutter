import 'package:ditonton/common/categorie_enum.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/movie_serach/movie_search_bloc.dart';
import 'package:ditonton/presentation/provider/movie_search_notifier.dart';
import 'package:ditonton/presentation/provider/tv_search_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/search';
  final categorie;
  SearchPage(this.categorie);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) {
                if (categorie == CategorieEnum.Movie) {
                  BlocProvider.of<MovieSearchBloc>(context, listen: false)
                      .add(SearchMoviesEvent(query));
                } else {
                  Provider.of<TvSearchNotifier>(context, listen: false)
                      .fetchTvSearch(query);
                }
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            Container(
                child: (categorie == CategorieEnum.Movie)
                    ? BuilderMovie()
                    : TvConsumer(categorie: categorie)),
          ],
        ),
      ),
    );
  }
}

class TvConsumer extends StatelessWidget {
  const TvConsumer({
    Key? key,
    required this.categorie,
  }) : super(key: key);

  final categorie;

  @override
  Widget build(BuildContext context) {
    return Consumer<TvSearchNotifier>(
      builder: (context, dataTv, child) {
        if (dataTv.state == RequestState.Loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (dataTv.state == RequestState.Loaded &&
            categorie == CategorieEnum.Tv) {
          final result = dataTv.searchResult;
          return Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final tv = dataTv.searchResult[index];
                return TvCard(tv);
              },
              itemCount: result.length,
            ),
          );
        } else {
          return Expanded(
            child: Container(),
          );
        }
      },
    );
  }
}

class BuilderMovie extends StatelessWidget {
  const BuilderMovie({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieSearchBloc, MovieSearchState>(
        builder: (context, state) {
      if (state is MovieSearchLoading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is MovieSearchLoaded) {
        return Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final movie = state.movies[index];
              return MovieCard(movie);
            },
            itemCount: state.movies.length,
          ),
        );
      }
      return Center(child: Text(state.message));
    });
  }
}
