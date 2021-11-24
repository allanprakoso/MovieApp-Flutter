import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
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
    Future.microtask(
        () => Provider.of<WatchlistMovieNotifier>(context, listen: false)
          ..fetchWatchlistMovies()
          ..fetchWatchlistTvs());
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
                child: Consumer<WatchlistMovieNotifier>(
                  builder: (context, data, child) {
                    if (data.watchlistState == RequestState.Loading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (data.watchlistState == RequestState.Loaded) {
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          if (categorie == 'Movie') {
                            final movie = data.watchlistMovies[index];
                            return MovieCard(movie);
                          }
                          final movie = data.watchlistTvs[index];
                          return TvCard(movie);
                        },
                        itemCount: (categorie == 'Movie')
                            ? data.watchlistMovies.length
                            : data.watchlistTvs.length,
                      );
                    } else {
                      return Center(
                        key: Key('error_message'),
                        child: Text(data.message),
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
