import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_rad_podcast_player/models/podcast.dart';
import 'package:the_rad_podcast_player/repositories/podcasts_repo.dart';

class PoscastPlayerScreen extends StatefulWidget {
  const PoscastPlayerScreen({
    required this.uuid,
    required this.episode,
    super.key,
  });
  final String uuid;
  final Episode episode;
  @override
  State<PoscastPlayerScreen> createState() => _PoscastPlayerScreenState();
}

class _PoscastPlayerScreenState extends State<PoscastPlayerScreen> {
  late AudioPlayer _player;
  Duration currentDuration = Duration(seconds: 0);
  bool isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool isLoading = false;
  @override
  void initState() {
    _player = AudioPlayer();

    // Listen to audio duration changes
    _player.onDurationChanged.listen((duration) {
      if (!mounted) return;
      setState(() {
        _duration = duration;
      });
    });

    // Listen to audio position changes
    _player.onPositionChanged.listen((position) {
      if (!mounted) return;
      setState(() {
        _position = position;
      });
    });

    loadEpisodedata();
    super.initState();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> loadEpisodedata() async {
    final prov = Provider.of<PodcastsRepo>(context, listen: false);
    await prov.getEpisodeDetails(uuid: widget.uuid);
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PodcastsRepo>(
      builder: (context, repo, child) => Scaffold(
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: repo.isLoading
                ? CircularProgressIndicator()
                : Column(
                    children: [
                      SingleChildScrollView(
                        child: Hero(
                          tag: repo.episode.uuid!,
                          child: ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(10),
                            child: SizedBox(
                              child: widget.episode.imageUrl == null
                                  ? Image.asset(
                                      'images/podcast.png',
                                      height: 400,
                                    )
                                  : Image.network(
                                      widget.episode.imageUrl!,
                                      height: 400,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(_formatDuration(_duration)),
                      SizedBox(height: 10),
                      Slider(
                        inactiveColor: Colors.white,
                        label: 'hello',
                        value: _position.inSeconds.toDouble(),
                        onChanged: (value) {
                          final seekPos = Duration(seconds: value.toInt());
                          _player.seek(seekPos);
                        },
                        max: double.parse(repo.episode.duration!.toString()),
                        min: 0,
                      ),
                      Text(_formatDuration(_position)),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () async {
                              if (isPlaying != true) {
                                setState(() {
                                  isLoading = true;
                                });

                                await _player.play(
                                  UrlSource(repo.episode.audioUrl!),
                                );
                              } else {
                                await _player.pause();
                              }

                              setState(() {
                                if (isPlaying == true) {
                                  isPlaying = false;
                                } else {
                                  isPlaying = true;
                                }
                                isLoading = false;
                              });
                            },
                            icon: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                            ),
                          ),
                          isLoading ? CircularProgressIndicator() : SizedBox(),
                          IconButton(
                            onPressed: () async {
                              await _player.stop();
                              setState(() {
                                isPlaying = false;
                              });
                            },
                            icon: Icon(Icons.stop),
                          ),

                          IconButton(
                            onLongPress: () async {
                              _player.seek(Duration(seconds: 0));
                            },
                            onPressed: () async {
                              final Duration pos =
                                  await _player.getCurrentPosition() ??
                                  Duration();
                              log(pos.toString());
                              await _player.seek(pos - Duration(seconds: 10));
                            },
                            icon: Icon(Icons.arrow_circle_left_outlined),
                          ),
                          IconButton(
                            onPressed: () async {
                              final Duration pos =
                                  await _player.getCurrentPosition() ??
                                  Duration();
                              log(pos.toString());
                              await _player.seek(pos + Duration(seconds: 10));
                            },
                            icon: Icon(Icons.arrow_circle_right_outlined),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
