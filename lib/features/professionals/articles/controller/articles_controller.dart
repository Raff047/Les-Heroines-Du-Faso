import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_app/core/type_defs.dart';
import 'package:health_app/features/professionals/articles/repository/articles_repository.dart';
import '../../../../core/common/widgets/show_snack_bar.dart';
import '../../../../models/article_model.dart';

// CLASS PROVIDER
final professionalArticleControllerProvider = Provider((ref) =>
    ProfessionalArticlesController(
        ref.read(professionalArticleRepositoryProvider)));

// my articles provider
final myArticlesProvider = FutureProvider.family((ref, String uid) {
  final professionalArticleController =
      ref.read(professionalArticleControllerProvider);
  return professionalArticleController.getProfessionalArticles(uid);
});

class ProfessionalArticlesController {
  final ProfessionalArticlesRepository _professionalArticlesRepository;

  ProfessionalArticlesController(this._professionalArticlesRepository);

  //post article to firestore
  void postArticle(Article article, BuildContext context) {
    try {
      _professionalArticlesRepository.postArticle(article);
      showSnackBar(context: context, content: 'Posted!');
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  // groupe all posted articles by a professional
  Future<List<Article>> getProfessionalArticles(String professionalId) async {
    return await _professionalArticlesRepository
        .getProfessionalArticles(professionalId);
  }

  // delete article by professional
  void deleteArticle(
      String articleId, String professionalId, BuildContext context) async {
    final res = await _professionalArticlesRepository.deleteArticle(
        articleId, professionalId);

    res.fold(
        (l) => showSnackBar(
            context: context, content: 'Error, please try again later.'),
        (r) => showSnackBar(context: context, content: 'Article supprimé'));
  }

  // update article by professional
  void editArticle(
      String articleId,
      String professionalId,
      String content,
      String title,
      String category,
      String imageUrl,
      BuildContext context) async {
    final res = await _professionalArticlesRepository.editArticle(
        articleId, professionalId, content, title, category, imageUrl);
    res.fold(
        (l) => showSnackBar(
            context: context,
            content:
                'une erreur s\'est produite, veuillez réessayer plus tard.'),
        (r) => showSnackBar(
            context: context, content: 'L\'article a été modifié'));
  }
}
