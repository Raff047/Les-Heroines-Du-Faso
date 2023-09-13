import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:health_app/core/failure.dart';
import 'package:health_app/core/providers/firebase_providers.dart';

import '../../../../core/type_defs.dart';
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

  // delete article by professional
  FutureVoid deleteArticle(String articleId, String professionalId) async {
    try {
      final articlesSnapshot = await _firestore
          .collection('articles')
          .where('authorId', isEqualTo: professionalId)
          .where(FieldPath.documentId, isEqualTo: articleId)
          .get();

      if (articlesSnapshot.docs.isNotEmpty) {
        return right(await articlesSnapshot.docs.first.reference.delete());
      } else {
        throw 'Article not found or you do not have permission to delete it.';
      }
    } on FirebaseException catch (e) {
      throw e.toString();
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // update article
  FutureVoid editArticle(String articleId, String professionalId,
      String content, String title, String category, String imageUrl) async {
    try {
      final articlesSnapshot = await _firestore
          .collection('articles')
          .where('authorId', isEqualTo: professionalId)
          .where(FieldPath.documentId, isEqualTo: articleId)
          .get();

      final articleDataToEdit = {
        'title': title,
        'content': content,
        'category': category,
        'imageUrl': imageUrl
      };

      if (articlesSnapshot.docs.isNotEmpty) {
        return right(await articlesSnapshot.docs.first.reference
            .update(articleDataToEdit));
      } else {
        throw 'Article not found or you do not have permission to delete it.';
      }
    } on FirebaseException catch (e) {
      throw e.toString();
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
