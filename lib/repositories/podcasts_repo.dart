import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:the_rad_podcast_player/models/podcast.dart';

class PodcastsRepo extends ChangeNotifier {
  List<Podcast> _podcasts = [];
  List<Podcast> get podcasts => _podcasts;

  Episode _episode = Episode();
  Episode get episode => _episode;

  bool _isloading = false;
  bool get isLoading => _isloading;

  final ValueNotifier<GraphQLClient> tadyClient;

  PodcastsRepo(this.tadyClient);

  Future<void> getPopularContent(int page, int limit) async {
    _isloading = true;

    //_podcasts = [];

    String query =
        '''
    query {
  getPopularContent(filterByLanguage: ENGLISH, page: $page, limitPerPage: $limit)
  {
    popularityRankId
    podcastSeries {
      uuid
      name
      datePublished
      description
      imageUrl
        totalEpisodesCount
      genres
      seriesType
      authorName
      episodes {
        uuid
        name
        datePublished
        audioUrl
        imageUrl
      }
    }
  }
}

  ''';

    final QueryOptions options = QueryOptions(
      document: gql(query),
      //variables: {'name': 'Your Podcast Name'},
    );

    final result = await tadyClient.value.query(options);

    if (result.hasException) {
      log(result.exception.toString());
      _isloading = false;
    } else {
      final res = result.data!['getPopularContent']['podcastSeries'];

      final List<Podcast> podcasts = (res as List<dynamic>)
          .map((item) => Podcast.fromJson(item))
          .toList();

      if (podcasts.isNotEmpty) {
        _podcasts.addAll(podcasts);
        _isloading = false;
        notifyListeners();
        podcasts.clear();
      }
    }
  }

  Future<void> searchPodcast(String term) async {
    _isloading = true;

    _podcasts = [];

    String query =
        '''
        {
      search(term: "$term", limitPerPage: 10) {
        searchId
        podcastSeries {
          uuid
          name
          datePublished
          description
          imageUrl
            totalEpisodesCount
          genres
          seriesType
          authorName
          episodes {
            uuid
            name
            datePublished
            audioUrl
            imageUrl
          }
        }
      }
    }
      ''';

    final QueryOptions options = QueryOptions(
      document: gql(query),
      //variables: {'name': 'Your Podcast Name'},
    );

    final result = await tadyClient.value.query(options);

    if (result.hasException) {
      log(result.exception.toString());
      _isloading = false;
    } else {
      final res = result.data!['search']['podcastSeries'];

      final List<Podcast> podcasts = (res as List<dynamic>)
          .map((item) => Podcast.fromJson(item))
          .toList();

      if (podcasts.isNotEmpty) {
        _podcasts.addAll(podcasts);
        _isloading = false;
        notifyListeners();
        podcasts.clear();
      }
    }
  }

  Future<void> getEpisodeDetails({required String uuid}) async {
    _isloading = true;

    String query =
        '''
      {
        getPodcastEpisode(uuid: "$uuid") {
          uuid
          description
          duration
          audioUrl
          imageUrl
          name
          datePublished
        }
      }
    ''';

    final QueryOptions options = QueryOptions(document: gql(query));

    final result = await tadyClient.value.query(options);

    if (result.hasException) {
      log(result.exception.toString());
      _isloading = false;
    } else {
      final res = result.data!['getPodcastEpisode'];
      final Episode episode = Episode.fromJson(res);
      _episode = episode;
      _isloading = false;
      notifyListeners();
    }
  }
}
