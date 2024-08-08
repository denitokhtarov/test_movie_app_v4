import 'dart:math';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:themovie/api_client/api_client.dart';
import 'package:themovie/entity/movie.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntroPosterWidget(
            collection: 'TOP_250_TV_SHOWS',
          ),
          SizedBox(
            height: 40,
          ),
          MoviesSection(
            collection: 'TOP_250_MOVIES',
            sectionName: 'Фильмы из топ-250',
          ),
          MoviesSection(
            collection: 'ZOMBIE_THEME',
            sectionName: 'Смотрят сейчас',
          ),
          MoviesSection(
            collection: 'TOP_250_TV_SHOWS',
            sectionName: 'Сериалы, от которых невозможно оторваться',
          ),
          MoviesSection(
            collection: 'COMICS_THEME',
            sectionName: 'Фильмы по комиксам',
          ),
          MoviesSection(
            collection: 'FAMILY',
            sectionName: 'Для всей семьи',
          ),
          MoviesSection(
            collection: 'CATASTROPHE_THEME',
            sectionName: 'Триллеры',
          ),
          MoviesSection(
            sectionName: 'Про любовь',
            collection: 'LOVE_THEME',
          ),
          MoviesSection(
            sectionName: 'Для детей',
            collection: 'KIDS_ANIMATION_THEME',
          ),
          MoviesSection(
            sectionName: 'Вам понравятся',
            collection: 'CLOSES_RELEASES',
          ),
          MoviesSection(
            sectionName: 'Про вампиров',
            collection: 'VAMPIRE_THEME',
          ),
          MoviesSection(
            sectionName: 'Популярные сериалы',
            collection: 'POPULAR_SERIES',
          ),
        ],
      ),
    );
  }
}

class IntroPosterWidget extends StatefulWidget {
  final String collection;
  const IntroPosterWidget({
    super.key,
    required this.collection,
  });

  @override
  State<IntroPosterWidget> createState() => _IntroPosterWidgetState();
}

class _IntroPosterWidgetState extends State<IntroPosterWidget> {
  PageController pageController = PageController(
    initialPage: 0,
    viewportFraction: 1,
  );
  int currentPage = 0;
  PopularMovies? movies;
  List<String> collections = [
    'ZOMBIE_THEME',
    'COMICS_THEME',
    'TOP_250_TV_SHOWS',
    'TOP_250_MOVIES',
    'FAMILY'
  ];

  final randomNumber = Random().nextInt(5);
  void getMovies() async {
    movies = await ApiClient.getMovies(collections[randomNumber], randomNumber);
    setState(() {});
  }

  void onPageChanged(int page) {
    currentPage = page;
    setState(
      () {},
    );
  }

  void onTap(int movieId) {
    Navigator.pushNamed(context, '/movie_details', arguments: movieId);
  }

  @override
  void initState() {
    getMovies();
    super.initState();
  }

  List<Widget> buildPageIndicatorWidget() {
    List<Widget> list = [];
    for (int i = 0; i < 5; i++) {
      list.add(i == currentPage ? indicator(true) : indicator(false));
    }
    return list;
  }

  Widget indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      height: 5,
      width: 5,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.white : Colors.white24,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (movies == null) {
      return const SizedBox.shrink();
    }
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.75,
          child: PageView.builder(
            physics: const BouncingScrollPhysics(),
            controller: pageController,
            itemCount: 5,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => onTap(movies!.items[index].kinopoiskId!),
                child: IntroPoster(
                  movie: movies!.items[index],
                ),
              );
            },
            onPageChanged: onPageChanged,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: buildPageIndicatorWidget(),
        ),
      ],
    );
  }
}

class IntroPoster extends StatelessWidget {
  const IntroPoster({
    super.key,
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(movie.coverUrl!),
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.center,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(0, 0, 0, 0),
                Color.fromARGB(255, 0, 0, 0),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              movie.logoUrl != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 10),
                      child: Image.network(movie.logoUrl!),
                    )
                  : Text(
                      textAlign: TextAlign.center,
                      movie.nameRu!,
                      style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.w900),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    movie.genres![0].genre!,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 7),
                  if (movie.ratingAgeLimits == 'age18')
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          '18+',
                          style: TextStyle(color: Colors.white, fontSize: 11),
                        ),
                      ),
                    )
                  else
                    const SizedBox.shrink()
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30, left: 10, right: 15),
                child: Text(
                  movie.description!,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.quicksand(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.normal),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class MoviesSection extends StatefulWidget {
  final String collection;
  final String sectionName;
  const MoviesSection({
    super.key,
    required this.sectionName,
    required this.collection,
  });

  @override
  State<MoviesSection> createState() => _MoviesSectionState();
}

class _MoviesSectionState extends State<MoviesSection> {
  PopularMovies? movies;

  void getMovies() async {
    movies = await ApiClient.getMovies(widget.collection, 1);
    setState(() {});
  }

  @override
  void initState() {
    getMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (movies == null) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  widget.sectionName,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {
                  final sectionName = widget.sectionName;
                  final collection = widget.collection;
                  Navigator.pushNamed(context, '/all_movies',
                      arguments: [sectionName, collection]);
                },
                child: const Text(
                  'Все',
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        MovieCardsRow(movies: movies!.items)
      ],
    );
  }
}

class MovieCardsRow extends StatelessWidget {
  final List<Movie> movies;
  const MovieCardsRow({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            height: 300,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              separatorBuilder: (context, index) => const SizedBox(
                width: 20,
              ),
              itemBuilder: (context, index) {
                return MovieCard(
                    height: 200, width: 150, movies: movies, index: index);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class MovieCard extends StatelessWidget {
  final double height;
  final double width;
  final List<Movie> movies;
  final int index;
  const MovieCard({
    super.key,
    required this.movies,
    required this.index,
    required this.height,
    required this.width,
  });

  void onMovieTap(BuildContext context, int movieID) {
    Navigator.pushNamed(context, '/movie_details', arguments: movieID);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            InkWell(
              onTap: () => onMovieTap(context, movies[index].kinopoiskId!),
              child: Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(movies[index].posterUrl!),
                  ),
                ),
              ),
            ),
            movies[index].ratingKinopoisk == null
                ? const SizedBox.shrink()
                : MovieRatingIndicator(movie: movies[index])
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          width: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                movies[index].nameRu!,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
              Text(
                movies[index].year?.toString() ?? '',
                style: const TextStyle(
                  color: Colors.white38,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class MovieRatingIndicator extends StatelessWidget {
  final Movie movie;
  const MovieRatingIndicator({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor;
    if (movie.ratingKinopoisk == null) {
      backgroundColor = Colors.green;
    } else {
      movie.ratingKinopoisk! >= 7
          ? backgroundColor = Colors.green
          : backgroundColor = Colors.orange;
    }
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        height: 20,
        width: 30,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Center(
            child: Text(
              movie.ratingKinopoisk.toString(),
              style: GoogleFonts.openSans(
                  color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }
}
