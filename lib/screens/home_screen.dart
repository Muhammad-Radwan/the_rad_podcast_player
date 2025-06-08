import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_rad_podcast_player/models/podcast.dart';
import 'package:the_rad_podcast_player/repositories/podcasts_repo.dart';
import 'package:the_rad_podcast_player/screens/podcast_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PodcastsRepo>(
      builder: (context, repo, child) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async => await repo.getPopularContent(),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                CupertinoTextField(
                  prefix: Icon(Icons.search),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    color: const Color(
                      0xFF1B2A3C,
                    ), // Your custom dark bluish background
                    borderRadius: BorderRadius.circular(8),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 10),
                repo.isLoading
                    ? CircularProgressIndicator()
                    : Expanded(
                        child: GridView.builder(
                          itemCount: repo.podcasts.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: 5,
                                crossAxisSpacing: 5,
                                crossAxisCount: 3,
                              ),
                          itemBuilder: (context, index) {
                            Podcast currentPodcast = repo.podcasts[index];
                            return ClipRRect(
                              borderRadius: BorderRadiusGeometry.circular(10),
                              child: InkWell(
                                onTap: () => Navigator.of(context).push(
                                  CupertinoPageRoute(
                                    builder: (context) => PodcastDetailsScreen(
                                      podcast: currentPodcast,
                                    ),
                                  ),
                                ),
                                child: SizedBox(
                                  child: Hero(
                                    tag: currentPodcast.uuid!,
                                    child: Image.network(
                                      height: 470,
                                      currentPodcast.imageUrl!,
                                    ),
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
    );
  }
}
