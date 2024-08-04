import 'package:flutter/material.dart';
import 'package:vertex_virtual/ui/create_article.dart';

import 'model/article.dart';
import 'ui/article_screen.dart';

navigateToCreateArticle(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => const CreateArticleScreen(),
  ));
}


navigateToArticle(BuildContext context, Article article) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => ArticleScreen(article),
  ));
}