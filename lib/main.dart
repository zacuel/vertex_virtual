import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vertex_virtual/features/auth/auth_repository.dart';
import 'package:vertex_virtual/features/theme/color_theme_provider.dart';
import 'package:vertex_virtual/max_votes_notifier.dart';
import 'package:vertex_virtual/ui/home_screen.dart';
import 'package:vertex_virtual/utility/error_loader.dart';
import 'features/articles/favorite_articles_provider.dart';
import 'ui/auth_screens/auth_screen.dart';
import 'utility/firebase_tools/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  void getData(User data) async {
    final person = await ref.read(authRepositoryProvider).getPersonData(data.uid).first;
    ref.read(personProvider.notifier).update((state) => person);
    ref.read(favoriteArticlesProvider.notifier).createListState(person.favoriteArticleIds);
    ref.read(maxVotesNotifierProvider.notifier).setValue();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "think tank",
      theme: ThemeData(colorScheme: ref.watch(colorThemeProvider)),
      home: ref.watch(authStateChangeProvider).when(
          data: (data) {
            if (data != null) {
              getData(data);
              return const HomeScreen();
            }
            return const AuthScreen();
          },
          error: (error, _) => ErrorPage(error.toString()),
          loading: () => const Loader()),
    );
  }
}
