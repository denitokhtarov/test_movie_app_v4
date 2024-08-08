import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:themovie/api_client/api_client.dart';
import 'package:themovie/entity/movie.dart';

class FilmPage extends StatelessWidget {
  const FilmPage({super.key});

  @override
  Widget build(BuildContext context) {
    FocusNode myFocus = FocusNode();

    return Scaffold(
      appBar: AppBar(
        title: CupertinoSearchTextField(
          onTap: () {
            myFocus.unfocus();
            Navigator.pushNamed(context, '/search_page');
          },
          focusNode: myFocus,
          style: const TextStyle(color: Colors.grey),
          placeholder: 'Поиск',
          backgroundColor: CupertinoColors.darkBackgroundGray,
        ),
      ),
      body: const MoviesGridView(),
    );
  }
}

class MoviesGridView extends StatefulWidget {
  const MoviesGridView({
    super.key,
  });

  @override
  State<MoviesGridView> createState() => _MoviesGridViewState();
}

class _MoviesGridViewState extends State<MoviesGridView> {
  PopularMovies? popularMovies;
  List<Movie> movies = [];
  final controller = ScrollController();
  bool isLoadingMore = false;
  int page = 1;

  void getMovies() async {
    popularMovies = await ApiClient.getMovies('TOP_250_MOVIES', page);
    setState(() {
      movies.addAll(popularMovies!.items);
    });
  }

  void scrollListener() {
    if (isLoadingMore) return;
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      setState(() {
        isLoadingMore = true;
      });
      page += 1;
      getMovies();
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  @override
  void initState() {
    getMovies();
    controller.addListener(scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (popularMovies == null) {
      return const Center(
        child: SizedBox.shrink(),
      );
    }
    return GridView.builder(
      controller: controller,
      itemCount: isLoadingMore ? movies.length + 1 : movies.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, childAspectRatio: 0.7),
      itemBuilder: (context, index) {
        if (index < movies.length) {
          return MovieCard(movies: movies, index: index);
        } else {
          return const Center(
            child: CircularProgressIndicator(color: Colors.red),
          );
        }
      },
    );
  }
}

class MovieCard extends StatelessWidget {
  final int index;
  final List<Movie> movies;
  const MovieCard({super.key, required this.movies, required this.index});

  void onMovieTap(BuildContext context, int id) {
    Navigator.pushNamed(context, '/movie_details', arguments: id);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () => onMovieTap(context, movies[index].kinopoiskId!),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            movies[index].posterUrl!,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
