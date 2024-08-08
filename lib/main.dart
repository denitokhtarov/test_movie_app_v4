import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:themovie/hive/box.dart';
import 'package:themovie/hive/movie_adapter.dart';
import 'package:themovie/movie_details/movie_trailer.dart';
import 'package:themovie/pages/feedPages/all_movies_from_section.dart';
import 'package:themovie/pages/filmsPages/search_page.dart';
import 'package:themovie/pages/home_page.dart';
import 'package:themovie/movie_details/movie_details.dart';
import 'package:themovie/pages/profile_pages/auth_page.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(MovieForSavedAdapter());
  movieBox = await Hive.openBox<MovieForSaved>('movieBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black, foregroundColor: Colors.white),
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
      ),
      home: const HomePage(),
      initialRoute: '/',
      routes: {
        '/auth_': (context) => const AuthPage(),
        '/movie_details': (context) {
          final movieId = ModalRoute.of(context)?.settings.arguments as int;
          return MovieDetailsWidget(id: movieId);
        },
        '/movie_details/trailer': (context) {
          final movieName =
              ModalRoute.of(context)?.settings.arguments as String;
          return MovieTrailer(
            movieName: movieName,
          );
        },
        '/search_page': (context) => const SearchPage(),
        '/all_movies': (context) {
          final List arguments =
              ModalRoute.of(context)!.settings.arguments as List;
          return AllMovies(
            title: arguments[0],
            collection: arguments[1],
          );
        }
      },
    );
  }
}
