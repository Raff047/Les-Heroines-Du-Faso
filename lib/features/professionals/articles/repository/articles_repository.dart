import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_app/core/providers/firebase_providers.dart';

import '../../../../models/article_model.dart';

// CLASS PROVIDER
final professionalArticleRepositoryProvider = Provider(
    (ref) => ProfessionalArticlesRepository(ref.read(firestoreProvider)));

class ProfessionalArticlesRepository {
  final FirebaseFirestore _firestore;

  ProfessionalArticlesRepository(this._firestore);

  //post article to firestore
  Future<void> postArticle(
    Article article,
  ) async {
    try {
      await _firestore
          .collection('articles')
          .doc(article.id)
          .set(article.toMap());
    } catch (e) {
      rethrow;
    }
  }

  // groupe all posted article by a professional
  Future<List<Article>> getProfessionalArticles(String professionalId) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('articles')
          .where('authorId', isEqualTo: professionalId)
          .get();

      final List<Article> articles =
          snapshot.docs.map((doc) => Article.fromMap(doc.data())).toList();

      return articles;
    } catch (e) {
      rethrow;
    }
  }
}
