import 'package:flutter/material.dart';
import 'package:vertex_virtual/ui/create_article.dart';

navigateToCreateArticle(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => const CreateArticleScreen(),
  ));
}
