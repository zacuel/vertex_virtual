import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/comment.dart';
import '../../utility/snackybar.dart';
import '../auth/auth_repository.dart';
import 'comments_repository.dart';

final articleCommentsProvider = StreamProvider.family<List<Comment>, String>((ref, String articleId) {
  final commentRepository = ref.read(commentsRepositoryProvider);
  return commentRepository.getArticleComments(articleId);
});


final commentsControllerProvider = Provider<CommentsController>((ref) {
  final commentsRepository = ref.read(commentsRepositoryProvider);
  return CommentsController(commentRepository: commentsRepository, ref: ref);
});

class CommentsController {
  final CommentsRepository _commentRepository;
  final Ref _ref;
  CommentsController({required CommentsRepository commentRepository, required Ref ref})
      : _commentRepository = commentRepository,
        _ref = ref;

  void addComment(BuildContext context, String articleId, String comment) async {
    final person = _ref.read(personProvider)!;

    final result = await _commentRepository.addComment(articleId, person.uid,  comment);
    result.fold((l) => showSnackBar(context, l.message), (r) => null);
  }


    Future<String> getUserComment(String articleId) async {
    final person = _ref.read(personProvider)!;
    final comment = await _commentRepository.getUserComment(articleId, person.uid);
    return comment;
  }


  Stream<List<Comment>> getArticleComments(String articleId) {
    return _commentRepository.getArticleComments(articleId);
  }
}
