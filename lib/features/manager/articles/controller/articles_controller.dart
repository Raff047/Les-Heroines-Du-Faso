import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_app/core/common/widgets/show_snack_bar.dart';
import 'package:health_app/features/manager/articles/repository/articles_repository.dart';

// CLASS PROVIDER
final managerArticlesController = Provider(
    (ref) => ManagerArticlesController(ref.read(managerArticlesRepository)));

class ManagerArticlesController {
  final ManagerArticlesRepository _managerArticlesRepository;

  ManagerArticlesController(this._managerArticlesRepository);

  // delete article
  void deleteArticle(String articleId, BuildContext context) async {
    final res = await _managerArticlesRepository.deleteArticle(articleId);
    res.fold(
        (l) => showSnackBar(context: context, content: 'Something went wrong.'),
        (r) => showSnackBar(context: context, content: 'Article supprimé'));
  }
}
