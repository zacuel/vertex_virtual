import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vertex_virtual/features/articles/articles_controller.dart';
import 'package:vertex_virtual/features/articles/favorite_articles_provider.dart';
import 'package:vertex_virtual/navigation.dart';
import 'package:vertex_virtual/utility/error_loader.dart';

import '../features/auth/auth_repository.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteArticles = ref.watch(favoriteArticlesProvider);
    final person = ref.watch(personProvider)!;
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: favoriteArticles.length,
        itemBuilder: (context, index) {
          final articleId = favoriteArticles[index];
          return ref.watch(articleByIdProvider(articleId)).when(
              data: (article) {
                return ListTile(
                  title: Text(article.title),
                  onTap: () => navigateToArticle(context, article),
                );
              },
              error: (error, _) => ListTile(
                    title: const Text('article is deleted, tap here to remove'),
                    onTap: () {
                      ref.read(favoriteArticlesProvider.notifier).removeUponDiscoveredDeletion(person.uid, articleId);
                    },
                  ),
              loading: () => const Loader());
        },
      ),
    );
  }
}
