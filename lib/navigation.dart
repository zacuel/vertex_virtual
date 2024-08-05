import 'package:flutter/material.dart';
import 'package:vertex_virtual/ui/auth_screens/link_account_screen.dart';
import 'package:vertex_virtual/ui/create_article_screen.dart';
import 'package:vertex_virtual/ui/favorites_screen.dart';
import 'package:vertex_virtual/ui/set_theme_page.dart';

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

navigateToTheming(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => const SetThemePage(),
  ));
}

navigateToLinkAccount(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => const LinkAccountScreen(),
  ));
}

navigateToFavoritesFeed(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => const FavoritesScreen(),
  ));
}
