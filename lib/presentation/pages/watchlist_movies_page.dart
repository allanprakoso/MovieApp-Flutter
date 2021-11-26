import 'package:ditonton/presentation/bloc/movie_watchlist/movie_watchlist_bloc.dart';
import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage> {
  String categorie = 'Movie';
  @override
  void initState() {
    super.initState();
    if (categorie == 'Movie') {
      BlocProvider.of<MovieWatchlistBloc>(context)
          .add(FetchMovieWatchlistEvent());
    } else {
      Future.microtask(() =>
          Provider.of<WatchlistMovieNotifier>(context, listen: false)
            ..fetchWatchlistTvs());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 95,
              margin: const EdgeInsets.only(left: 10, bottom: 10),
              child: DropdownButton<String>(
                value: categorie,
                items: <String>['Movie', 'Tv Series'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    categorie = value.toString();
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                child: BlocBuilder<MovieWatchlistBloc, MovieWatchlistState>(
                  builder: (context, state) {
                    if (state is MovieWatchlistLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is MovieWatchlistLoaded) {
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          final movie = state.movies[index];
                          return MovieCard(movie);
                        },
                        itemCount: state.movies.length,
                      );
                    } else {
                      return Center(
                        key: Key('error_message'),
                        child: Text(state.message),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
