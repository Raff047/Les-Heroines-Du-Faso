import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:health_app/core/failure.dart';
import 'package:health_app/core/providers/firebase_providers.dart';
import 'package:health_app/core/type_defs.dart';

// CLASS PROVIDER

final professionalProfileRepository = Provider(
    (ref) => ProfessionalProfileRepository(ref.read(firestoreProvider)));

class ProfessionalProfileRepository {
  final FirebaseFirestore _firestore;

  ProfessionalProfileRepository(this._firestore);

  // Professional users collection reference
  final CollectionReference<Map<String, dynamic>> _professionalUsersCollection =
      FirebaseFirestore.instance
          .collection('users')
          .doc('professionals')
          .collection('professionals');

  // update profile picture.
  FutureVoid updateProfilePic(String uid, String profilePic) async {
    try {
      final snapshot = await _professionalUsersCollection
          .doc(uid)
          .update({'profilePic': profilePic});
      return right(snapshot);
    } on FirebaseException catch (e) {
      throw e.toString();
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // update name.
  FutureVoid updateName(String uid, String name) async {
    try {
      final snapshot =
          await _professionalUsersCollection.doc(uid).update({'name': name});
      return right(snapshot);
    } on FirebaseException catch (e) {
      throw e.toString();
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
