import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:the_rad_podcast_player/repositories/podcasts_repo.dart';
import 'package:the_rad_podcast_player/screens/home_screen.dart';
import 'package:the_rad_podcast_player/themes/themes.dart';

void main() {
  final HttpLink httpLink = HttpLink(
    'https://api.taddy.org/graphql',
    defaultHeaders: {
      "X-USER-ID": "2922",
      "X-API-KEY":
          "2476bc45377a0e3605dd6a4d185c9b8a6fafa625ea812bbbe28e5e45a721fc7e66516aef5b54224d4d532a50b3524896c4", // Replace with your actual API key
    },
  );

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: InMemoryStore()),
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PodcastsRepo(client)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      home: const HomeScreen(),
    );
  }
}
