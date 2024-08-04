import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vertex_virtual/features/auth/auth_repository.dart';

import 'articles_repository.dart';



final favoriteArticlesProvider = StateNotifierProvider<FavoriteArticlesNotifier, List<String>>((ref) {
  final articleRepo = ref.read(articlesRepositoryProvider);
  final authRepo = ref.read(authRepositoryProvider);
  return FavoriteArticlesNotifier(articlesRepository: articleRepo, authRepository: authRepo, ref: ref);
});

class FavoriteArticlesNotifier extends StateNotifier<List<String>> {
  final ArticlesRepository _articlesRepository;
  final AuthRepository _authRepository;
  final Ref _ref;
  FavoriteArticlesNotifier({required ArticlesRepository articlesRepository, required AuthRepository authRepository, required Ref ref})
      : _articlesRepository = articlesRepository,
        _authRepository = authRepository,
        _ref = ref,
        super([]);

  void toggleArticleFavoriteStatus(String articleId) {
    final isFavorite = state.contains(articleId);
    final userId = _ref.read(personProvider)!.uid;
    if (isFavorite) {
      state = state.where((element) => element != articleId).toList();
      _articlesRepository.downvote(articleId, userId);
      _authRepository.downvote(userId, articleId);
    } else {
      state = [...state, articleId];
      _articlesRepository.upvote(articleId, userId);
      _authRepository.upvote(userId, articleId);
    }
  }

    void createListState(List<String> articleList) {
    state = articleList;
  }
}
