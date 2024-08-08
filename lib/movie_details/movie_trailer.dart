import 'package:flutter/material.dart';
import 'package:themovie/api_client/api_client.dart';
import 'package:themovie/entity/youtube_video_id.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieTrailer extends StatefulWidget {
  final String movieName;
  const MovieTrailer({super.key, required this.movieName});

  @override
  State<MovieTrailer> createState() => _MovieTrailerState();
}

class _MovieTrailerState extends State<MovieTrailer> {
  YouTubeVideoID? trailerId;

  void getMovieTrailer(String movieName) async {
    trailerId = await ApiClient.getYouTubeVideoID(movieName);
    setState(() {});
  }

  @override
  void initState() {
    getMovieTrailer(widget.movieName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (trailerId == null) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.red,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      ),
      body: MoviePlayer(trailerId: trailerId!.items[0].id!.videoId!),
    );
  }
}

class MoviePlayer extends StatefulWidget {
  final String trailerId;
  const MoviePlayer({
    super.key,
    required this.trailerId,
  });

  @override
  State<MoviePlayer> createState() => _MoviePlayerState();
}

class _MoviePlayerState extends State<MoviePlayer> {
  late YoutubePlayerController controller;

  @override
  void initState() {
    controller = YoutubePlayerController(
      initialVideoId: widget.trailerId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    super.initState();
  }

  @override
  void deactivate() {
    controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        YoutubePlayer(
          controller: controller,
          showVideoProgressIndicator: true,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
