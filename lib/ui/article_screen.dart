import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vertex_virtual/ui/comment_widgets/add_comment_widget.dart';
import 'package:vertex_virtual/ui/comment_widgets/comments_widget.dart';
import 'package:vertex_virtual/max_votes_notifier.dart';

import '../features/articles/favorite_articles_provider.dart';
import '../features/comments/comments_controller.dart';
import '../model/article.dart';
import '../utility/snackybar.dart';

class ArticleScreen extends ConsumerStatefulWidget {
  final Article article;
  const ArticleScreen(this.article, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends ConsumerState<ArticleScreen> {
  bool _showVoteButton = false;
  bool _isCommenting = false;
  bool _showComments = false;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserComment();
  }

  void _getUserComment() async {
    _commentController.text = await ref.read(commentsControllerProvider).getUserComment(widget.article.articleId);
  }

  void _addComment() async {
    ref.read(commentsControllerProvider).addComment(context, widget.article.articleId, _commentController.text.trim());
    setState(() {
      _isCommenting = false;
    });
  }

  _vote(int listLength, bool isUpvote, int maxVotes) {
    if (!isUpvote) {
      ref.read(favoriteArticlesProvider.notifier).toggleArticleFavoriteStatus(widget.article.articleId);
    } else if (listLength < maxVotes) {
      ref.read(favoriteArticlesProvider.notifier).toggleArticleFavoriteStatus(widget.article.articleId);
    } else {
      showSnackBar(context, 'Max Upvotes Reached');
    }
    setState(() {
      _showVoteButton = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final favList = ref.watch(favoriteArticlesProvider);
    final isFav = favList.contains(widget.article.articleId);
    final maxVotes = ref.watch(maxVotesNotifierProvider);
    return Scaffold(
      floatingActionButton: _showVoteButton
          ? FloatingActionButton(
              onPressed: () => _vote(favList.length, !isFav, maxVotes),
              child: Icon(isFav ? Icons.remove : Icons.thumb_up),
            )
          : null,
      appBar: AppBar(
        title: Text(widget.article.title),
        actions: [
          if (isFav) const Icon(Icons.star),
          // const SizedBox(width: 15),
          PopupMenuButton(
            onSelected: (value) {
              if (value == 'vote') {
                setState(() {
                  _showVoteButton = !_showVoteButton;
                });
              } else if (value == 'show') {
                setState(() {
                  _showComments = !_showComments;
                });
              } else if (value == 'write') {
                setState(() {
                  _isCommenting = !_isCommenting;
                });
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'vote', child: Text('show vote button')),
              PopupMenuItem(value: 'show', child: Text('view comments')),
              PopupMenuItem(value: 'write', child: Text('make comment')),
            ],
            icon: const Icon(Icons.menu),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 12,
              ),
              if (widget.article.url != null)
                TextButton(
                    onPressed: () async {
                      final Uri linkUrl = Uri.parse(widget.article.url!);
                      if (!await launchUrl(linkUrl)) {
                        throw Exception('Could not launch ${widget.article.url!}');
                      }
                    },
                    child: Text(
                      widget.article.url!,
                      style: const TextStyle(fontSize: 20),
                    )),
              const SizedBox(
                height: 10,
              ),
              if (widget.article.content != null) Expanded(flex: 2, child: SingleChildScrollView(child: Text(widget.article.content!))),
              //TODO configure so expanded works with no content
              if (_showComments) Expanded(flex: 1, child: CommentsWidget(widget.article.articleId)),
              if (_isCommenting) AddCommentWidget(commentFieldController: _commentController, changeComment: _addComment),
            ],
          ),
        ),
      ),
    );
  }
}
