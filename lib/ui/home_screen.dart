import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vertex_virtual/features/auth/auth_repository.dart';
import 'package:vertex_virtual/max_votes_notifier.dart';
import 'package:vertex_virtual/navigation.dart';

import '../features/articles/articles_controller.dart';
import '../features/articles/favorite_articles_provider.dart';
import '../utility/error_loader.dart';
import '../utility/snackybar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  _navToArticleCreation(BuildContext context, int upvoteListLength, int maxUpvotes) {
    if (upvoteListLength < maxUpvotes) {
      navigateToCreateArticle(context);
    } else {
      showSnackBar(context, 'max upvotes reached');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final person = ref.watch(personProvider)!;
    final maxValue = ref.watch(maxVotesNotifierProvider);
    final favList = ref.watch(favoriteArticlesProvider);
    return Scaffold(
      appBar: AppBar(
        // title: Text("think"),
        leading: PopupMenuButton(
          onSelected: (value) {
            if (value == 'authenticate') {
              navigateToLinkAccount(context);
            } else if (value == 'theme') {
              navigateToTheming(context);
            } else if (value == 'favList') {
              navigateToFavoritesFeed(context);
            }
          },
          itemBuilder: (context) {
            return [
              if (!person.isAuthenticated) const PopupMenuItem(value: "authenticate", child: Text("create account")),
              const PopupMenuItem(value: "theme", child: Text('set theme')),
              const PopupMenuItem(value: "favList", child: Text('view your selections')),
            ];
          },
          icon: const Icon(Icons.person),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => _navToArticleCreation(context, favList.length, maxValue),
            child: const Text('post'),
          ),
        ],
      ),
      body: ref.watch(articleFeedProvider).when(
          data: (data) {
            data.sort(
              (a, b) => b.upvoteIds.length.compareTo(a.upvoteIds.length),
            );
            return ListView.builder(
              itemCount: data.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [Text('      title'), Text('score   ')],
                        ),
                        Divider(),
                      ],
                    ),
                  );
                }
                final article = data[index - 1];
                return ListTile(
                  onTap: () {
                    navigateToArticle(context, article);
                  },
                  title: Text(article.title),
                  trailing: Text("${article.upvoteIds.length.toString()}  "),
                );
              },
            );
          },
          error: (error, _) => ErrorText(error.toString()),
          loading: () => const Loader()),
    );
  }
}
