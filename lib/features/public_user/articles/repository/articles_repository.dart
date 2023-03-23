import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/firebase_providers.dart';
import '../../../../models/article_model.dart';

final publicUserArticlesRepositoryProvider = Provider(
  (ref) => PublicUserArticlesRepository(
    ref.read(firestoreProvider),
  ),
);

class PublicUserArticlesRepository {
  final FirebaseFirestore _firestore;

  PublicUserArticlesRepository(this._firestore);

  // Load articles from firestore
  Future<List<Article>> fetchArticles() async {
    final articles = <Article>[];
    final snapshot = await _firestore.collection('articles').get();
    snapshot.docs.forEach((doc) {
      final data = doc.data();
      final article = Article.fromMap(data);
      articles.add(article);
    });
    return articles;
  }
}
