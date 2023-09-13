import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:health_app/core/failure.dart';
import 'package:health_app/core/type_defs.dart';

// CLASS PROVIDER

final publicUserProfileRepository =
    Provider((ref) => PublicUserProfileRepository());

class PublicUserProfileRepository {
  // Manager users collection reference
  final CollectionReference<Map<String, dynamic>> _publicUsersCollection =
      FirebaseFirestore.instance
          .collection('users')
          .doc('publicUsers')
          .collection('publicUsers');

  // update profile picture.
  FutureVoid updateProfilePic(String uid, String profilePic) async {
    try {
      final snapshot = await _publicUsersCollection
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
          await _publicUsersCollection.doc(uid).update({'name': name});
      return right(snapshot);
    } on FirebaseException catch (e) {
      throw e.toString();
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // update phone number.
  FutureVoid updatePhoneNumber(String uid, String phoneNumber) async {
    try {
      final snapshot = await _publicUsersCollection
          .doc(uid)
          .update({'phoneNumber': phoneNumber});
      return right(snapshot);
    } on FirebaseException catch (e) {
      throw e.toString();
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
