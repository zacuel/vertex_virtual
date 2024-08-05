import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vertex_virtual/features/comments/comments_controller.dart';
import 'package:vertex_virtual/utility/error_loader.dart';

class CommentsWidget extends ConsumerWidget {
  final String articleId;
  const CommentsWidget(this.articleId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(articleCommentsProvider(articleId)).when(
        data: (articleComments) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: articleComments
                  .map((e) => Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(border: Border.all()),
                          child: Text(e.commentText),
                        ),
                      ))
                  .toList(),
            ),
          );
        },
        error: (error, _) => ErrorText(error.toString()),
        loading: () => const Loader());
  }
}
