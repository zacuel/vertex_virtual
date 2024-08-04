import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';


import '../features/articles/favorite_articles_provider.dart';
import '../model/article.dart';
import '../utility/snackybar.dart';

class ArticleScreen extends ConsumerStatefulWidget {
  final Article article;
  const ArticleScreen(this.article, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends ConsumerState<ArticleScreen> {
  bool _showVoteButton = true;

  _vote(int listLength, bool isUpvote) {
    if(!isUpvote){
      ref.read(favoriteArticlesProvider.notifier).toggleArticleFavoriteStatus(widget.article.articleId);
    }
    //TODO change post limit
    else if (listLength < 5) {
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

    return Scaffold(
      floatingActionButton: _showVoteButton
          ? FloatingActionButton(
              onPressed: () => _vote(favList.length, !isFav),
              child: Icon(isFav ? Icons.remove : Icons.thumb_up),
            )
          : null,
      appBar: AppBar(
        title: Text(widget.article.title),
        actions: [
          if (isFav) const Icon(Icons.star),
          const SizedBox(
            width: 15,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
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
            if (widget.article.content != null) Text(widget.article.content!),
            const SizedBox(
              height: 45,
            ),

          ],
        ),
      ),
    );
  }
}
