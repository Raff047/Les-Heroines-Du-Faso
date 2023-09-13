import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:health_app/core/failure.dart';
import 'package:health_app/core/providers/firebase_providers.dart';
import 'package:health_app/core/type_defs.dart';

// CLASS PROVIDER
final managerArticlesRepository =
    Provider((ref) => ManagerArticlesRepository(ref.read(firestoreProvider)));

class ManagerArticlesRepository {
  final FirebaseFirestore _firestore;

  ManagerArticlesRepository(this._firestore);

  // delete article
  FutureVoid deleteArticle(String articleId) async {
    try {
      final articlesSnapshot =
          await _firestore.collection('articles').doc(articleId).delete();
      return right(articlesSnapshot);
    } on FirebaseException catch (e) {
      throw e.toString();
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
