class Podcast {
  String? uuid;
  String? name;
  int? datePublished;
  String? description;
  String? imageUrl;
  int? totalEpisodesCount;
  List<String>? genres;
  String? seriesType;
  String? authorName;
  List<Episode>? episodes;

  Podcast({
    this.uuid,
    this.name,
    this.datePublished,
    this.description,
    this.imageUrl,
    this.totalEpisodesCount,
    this.genres,
    this.seriesType,
    this.authorName,
    this.episodes,
  });

  factory Podcast.fromJson(Map<String, dynamic> json) => Podcast(
    uuid: json["uuid"],
    name: json["name"],
    datePublished: json["datePublished"],
    description: json["description"],
    imageUrl: json["imageUrl"],
    totalEpisodesCount: json["totalEpisodesCount"],
    genres: json["genres"] == null
        ? []
        : List<String>.from(json["genres"]!.map((x) => x)),
    seriesType: json["seriesType"],
    authorName: json["authorName"],
    episodes: json["episodes"] == null
        ? []
        : List<Episode>.from(json["episodes"]!.map((x) => Episode.fromJson(x))),
  );
}

class Episode {
  String? uuid;
  String? name;
  int? datePublished;
  String? audioUrl;
  String? imageUrl;
  int? duration;

  Episode({
    this.uuid,
    this.name,
    this.datePublished,
    this.audioUrl,
    this.imageUrl,
    this.duration
  });

  factory Episode.fromJson(Map<String, dynamic> json) => Episode(
    uuid: json["uuid"],
    name: json["name"],
    datePublished: json["datePublished"],
    audioUrl: json["audioUrl"],
    imageUrl: json["imageUrl"],
    duration: json["duration"],
  );
}
