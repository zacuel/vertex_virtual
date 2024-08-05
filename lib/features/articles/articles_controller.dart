import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';



import '../../model/article.dart';
import '../../utility/snackybar.dart';
import 'articles_repository.dart';
import 'favorite_articles_provider.dart';

final articleByIdProvider = StreamProvider.family<Article, String>((ref, String articleId) {
  final articlesController = ref.read(articlesControllerProvider.notifier);
  return articlesController.streamArticleById(articleId);
});


final articleFeedProvider = StreamProvider<List<Article>>((ref) {
  final articlesController = ref.read(articlesControllerProvider.notifier);
  return articlesController.articleFeed;
});

final articlesControllerProvider = StateNotifierProvider<ArticlesController, bool>((ref) {
  final articlesRepo = ref.read(articlesRepositoryProvider);
  return ArticlesController(articlesRepository: articlesRepo, ref: ref);
});

class ArticlesController extends StateNotifier<bool> {
  final ArticlesRepository _articlesRepository;
  final Ref _ref;

  ArticlesController({required ArticlesRepository articlesRepository, required Ref ref})
      : _articlesRepository = articlesRepository,
        _ref = ref,
        super(false);

  Future<void> postArticle({
    required String title,
    String? url,
    String? content,
    required BuildContext context,
  }) async {
    state = true;
    final newId = const Uuid().v1();
    // final person = _ref.read(personProvider)!;
    final newArticle = Article(
      articleId: newId,
      title: title,
      upvoteIds: [],
      url: url,
      content: content,
    );
    final result = await _articlesRepository.postArticle(newArticle);
    state = false;
    result.fold((l) => showSnackBar(context, l.message), (r) {
      _ref.read(favoriteArticlesProvider.notifier).toggleArticleFavoriteStatus(newArticle.articleId);
      showSnackBar(context, 'Posted!');
      Navigator.of(context).pop();
    });
  }

  Stream<List<Article>> get articleFeed => _articlesRepository.articleFeed;

    Stream<Article> streamArticleById(String articleId) => _articlesRepository.streamArticleById(articleId);
}
