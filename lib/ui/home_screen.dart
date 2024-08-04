import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vertex_virtual/features/auth/auth_repository.dart';
import 'package:vertex_virtual/navigation.dart';

import '../features/articles/articles_controller.dart';
import '../utility/error_loader.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final person = ref.watch(personProvider)!;
    return Scaffold(
      appBar: AppBar(
        leading: PopupMenuButton(
          onSelected: (value) {
            if (value == 'authenticate') {
              navigateToLinkAccount(context);
            } else if (value == 'theming') {
              navigateToTheming(context);
            }
          },
          itemBuilder: (context) {
            return [
              if (!person.isAuthenticated) const PopupMenuItem(value: "authenticate", child: Text("create account")),
              const PopupMenuItem(value: "theming", child: Text('set theme')),
            ];
          },
          icon: const Icon(Icons.person),
        ),
        //TODO max upvotes
        actions: [
          OutlinedButton(
            onPressed: () => navigateToCreateArticle(context),
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
                  return const Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [Text('      title'), Text('score   ')],
                      ),
                      Divider(),
                    ],
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
