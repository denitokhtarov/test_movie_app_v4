import 'package:flutter/material.dart';
import 'package:themovie/api_client/api_client.dart';
import 'package:themovie/entity/movie.dart';
import 'package:themovie/pages/feedPages/feed_page.dart';

class AllMovies extends StatelessWidget {
  final String collection;
  final String title;
  const AllMovies({super.key, required this.title, required this.collection});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title),
      ),
      body: MoviesGridVIew(collection: collection),
    );
  }
}

class MoviesGridVIew extends StatefulWidget {
  final String collection;
  const MoviesGridVIew({super.key, required this.collection});

  @override
  State<MoviesGridVIew> createState() => _MoviesGridVIewState();
}

class _MoviesGridVIewState extends State<MoviesGridVIew> {
  final controller = ScrollController();
  int page = 1;
  bool isLoadingMore = false;
  PopularMovies? movies;
  List<Movie> allMovies = [];

  void getMovies() async {
    movies = await ApiClient.getMovies(widget.collection, page);

    setState(() {
      allMovies.addAll(movies!.items);
    });
  }

  void scrollListener() {
    if (isLoadingMore) return;
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      setState(() {
        isLoadingMore = true;
      });
      page = page + 1;

      getMovies();
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  @override
  void initState() {
    controller.addListener(scrollListener);
    getMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (movies == null) return const SizedBox.shrink();
    return GridView.builder(
      controller: controller,
      itemCount: isLoadingMore ? allMovies.length + 1 : allMovies.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 0.75, crossAxisSpacing: 0),
      itemBuilder: (BuildContext context, int index) {
        if (index < allMovies.length) {
          return MovieCard(
            movies: allMovies,
            index: index,
            height: 225,
            width: 175,
          );
        } else {
          return const CircularProgressIndicator(color: Colors.red);
        }
      },
    );
  }
}
