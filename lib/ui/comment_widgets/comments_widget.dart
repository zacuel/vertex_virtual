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
          return Column(
            children: articleComments
                .map((e) => Column(
                      children: [
                        Text(e.commentText),
                        const Divider(),
                      ],
                    ))
                .toList(),
          );
        },
        error: (error, _) => ErrorText(error.toString()),
        loading: () => const Loader());
  }
}
