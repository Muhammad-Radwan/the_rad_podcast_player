import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_rad_podcast_player/models/podcast.dart';
import 'package:the_rad_podcast_player/repositories/podcasts_repo.dart';
import 'package:the_rad_podcast_player/screens/poscast_player_screen.dart';
import 'package:intl/intl.dart' as intl;

class PodcastDetailsScreen extends StatefulWidget {
  const PodcastDetailsScreen({required this.podcast, super.key});
  final Podcast podcast;
  @override
  State<PodcastDetailsScreen> createState() => _PodcastDetailsScreenState();
}

class _PodcastDetailsScreenState extends State<PodcastDetailsScreen> {
  String timeStampToDate(int timestamp) {
    // Convert seconds to milliseconds
    DateTime date = DateTime.fromMillisecondsSinceEpoch(
      timestamp * 1000,
      isUtc: true,
    );

    // Format the date using intl
    String formattedDate = intl.DateFormat(
      'yyyy-MM-dd HH:mm:ss',
    ).format(date.toLocal());

    return formattedDate; // Example output: 2025-06-01 10:00:00 (depends on timezone)
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PodcastsRepo>(
      builder: (context, repo, child) => Scaffold(
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Hero(
                    tag: widget.podcast.uuid!,
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(10),
                      child: SizedBox(
                        child: Image.network(
                          widget.podcast.imageUrl!,
                          height: 400,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    widget.podcast.name!,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  Text(
                    '${widget.podcast.totalEpisodesCount!} episodes',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    'By: ${widget.podcast.authorName!}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Divider(thickness: 0.1),
                  Text(
                    widget.podcast.description!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Divider(thickness: 0.1),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      itemCount: widget.podcast.episodes!.length,
                      itemBuilder: (context, index) {
                        final Episode currentEpisode =
                            widget.podcast.episodes![index];
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) => PoscastPlayerScreen(
                                  uuid: currentEpisode.uuid!,
                                  episode: currentEpisode,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            child: Padding(
                              padding: EdgeInsetsGeometry.all(10),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Hero(
                                        tag: currentEpisode.uuid!,
                                        child: currentEpisode.imageUrl == null
                                            ? Image.asset(
                                                'images/podcast.png',
                                                height: 100,
                                              )
                                            : Image.network(
                                                currentEpisode.imageUrl!,
                                                height: 100,
                                                loadingBuilder: (context, child, loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  return Center(
                                                    child: CircularProgressIndicator(
                                                      value:
                                                          loadingProgress
                                                                  .expectedTotalBytes !=
                                                              null
                                                          ? loadingProgress
                                                                    .cumulativeBytesLoaded /
                                                                (loadingProgress
                                                                        .expectedTotalBytes ??
                                                                    1)
                                                          : null,
                                                    ),
                                                  );
                                                },
                                              ),
                                      ),
                                      SizedBox(width: 10),
                                      Text('${currentEpisode.name}'),
                                    ],
                                  ),
                                  Text(
                                    timeStampToDate(
                                      currentEpisode.datePublished!,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
