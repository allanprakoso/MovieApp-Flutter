import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/bloc/tv_list/tv_list_bloc.dart';
import 'package:ditonton/presentation/pages/popular_tvs_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tvs_page.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/presentation/widgets/build_sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TvPage extends StatefulWidget {
  @override
  _TvPageState createState() => _TvPageState();
}

class _TvPageState extends State<TvPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<TvListBloc>(context).add(FetchTvListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(child: BlocBuilder<TvListBloc, TvListState>(
        builder: (context, state) {
          if (state is TvListLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is TvListLoaded) {
            return Content(
              nowPlayingTvs: state.nowPlayingTvs,
              popularTvs: state.popularTvs,
              topRatedTvs: state.topRatedTvs,
            );
          }
          return Center(
            child: Text(state.message),
          );
        },
      )),
    );
  }
}

class Content extends StatelessWidget {
  final List<Tv> nowPlayingTvs;
  final List<Tv> popularTvs;
  final List<Tv> topRatedTvs;

  const Content(
      {required this.nowPlayingTvs,
      required this.popularTvs,
      required this.topRatedTvs});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tvs',
          style: kHeading5,
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          'Now Playing',
          style: kHeading6,
        ),
        TvList(nowPlayingTvs),
        BuildSubHeading(
          title: 'Popular',
          onTap: () => Navigator.pushNamed(context, PopularTvsPage.ROUTE_NAME),
        ),
        TvList(popularTvs),
        BuildSubHeading(
          title: 'Top Rated',
          onTap: () => Navigator.pushNamed(context, TopRatedTvsPage.ROUTE_NAME),
        ),
        TvList(topRatedTvs)
      ],
    );
  }
}

class TvList extends StatelessWidget {
  final List<Tv> tvs;

  TvList(this.tvs);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = tvs[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvDetailPage.ROUTE_NAME,
                  arguments: tv.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvs.length,
      ),
    );
  }
}
