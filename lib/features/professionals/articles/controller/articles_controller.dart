import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_app/features/professionals/articles/repository/articles_repository.dart';
import '../../../../core/common/widgets/show_snack_bar.dart';
import '../../../../models/article_model.dart';

// CLASS PROVIDER
final professionalArticleControllerProvider = Provider((ref) =>
    ProfessionalArticlesController(
        ref.read(professionalArticleRepositoryProvider)));

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

  // groupe all posted article by a professional
  Future<List<Article>> getProfessionalArticles(String professionalId) async {
    return await _professionalArticlesRepository
        .getProfessionalArticles(professionalId);
  }
}
