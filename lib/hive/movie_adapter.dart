import 'package:hive_flutter/adapters.dart';

part 'movie_adapter.g.dart';

@HiveType(typeId: 1)
class MovieForSaved {
  @HiveField(0)
  String movieName;

  @HiveField(1)
  String moviePoster;

  @HiveField(2)
  String movieYear;

  @HiveField(3)
  bool isSaved = false;

  @HiveField(4)
  String? kinopoiskId;
  MovieForSaved({
    required this.movieName,
    required this.moviePoster,
    required this.movieYear,
    required this.isSaved,
    required this.kinopoiskId,
  });
}
