import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:themovie/hive/box.dart';
import 'package:themovie/hive/movie_adapter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SavedFilmsPage extends StatefulWidget {
  final Function callback;
  const SavedFilmsPage(this.callback, {super.key});

  @override
  State<SavedFilmsPage> createState() => _SavedFilmsPageState();
}

class _SavedFilmsPageState extends State<SavedFilmsPage> {
  void onTap(int movieId) {
    Navigator.pushNamed(context, '/movie_details', arguments: movieId).then((onValue) => setState(() {
      
    }));
  }
  
  @override
  Widget build(BuildContext context) {
    List<MovieForSaved> movieBoxValues =
        movieBox.values.toList() as List<MovieForSaved>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
        centerTitle: true,
      ),
      body: movieBoxValues.isEmpty
          ? const Center(
              child: Text('У вас нет сохраненных фильмов'),
            )
          : ListView.builder(
              itemCount: movieBox.length,
              itemBuilder: (context, index) {
                final MovieForSaved movie = movieBoxValues[index];
                 return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Slidable(
                    endActionPane: ActionPane(motion: const ScrollMotion(), children: [
                      SlidableAction(

                        onPressed: (context) async {
                          await movieBox.delete(movie.kinopoiskId);
                          setState(() {});
                        },
                        borderRadius: const BorderRadius.only(topRight: Radius.circular(12),bottomRight: Radius.circular(12)),
                        backgroundColor: Colors.red,
                        label: 'Удалить',
                      )
                    ]),
                    child: GestureDetector(
                      onTap: () => onTap(int.parse(movie.kinopoiskId!)),
                      child: SizedBox(
                        height: 150,
                        width: MediaQuery.of(context).size.width * 1,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: CupertinoColors.darkBackgroundGray,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    bottomLeft: Radius.circular(12),
                                  ),
                                  child: Image.network(
                                    movie.moviePoster,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.5,
                                      child: Text(
                                        maxLines: 2,
                                        movie.movieName,
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ),
                                    Text(
                                      movie.movieYear,
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}


