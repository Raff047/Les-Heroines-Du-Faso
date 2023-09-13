import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_app/features/public_user/articles/repository/articles_repository.dart';
import '../../../../models/article_model.dart';

final publicUserArticlesControllerProvider = Provider(
  (ref) => PublicUserArticlesController(
    ref.read(publicUserArticlesRepositoryProvider),
  ),
);

class PublicUserArticlesController {
  final PublicUserArticlesRepository _publicUserArticlesRepository;

  PublicUserArticlesController(this._publicUserArticlesRepository);

  // Load articles from firestore
  Future<List<Article>> fetchArticles() async {
    return _publicUserArticlesRepository.fetchArticles();
  }
}
