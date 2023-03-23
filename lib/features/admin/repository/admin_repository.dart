import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_app/core/constants/constants.dart';
import 'package:health_app/core/providers/firebase_providers.dart';
import 'package:health_app/models/admin_user_model.dart';
import 'package:health_app/models/manager_user_model.dart';
import 'package:health_app/models/professional_user_model.dart';

final adminRepositoryProvider = Provider((ref) => AdminRepository(
      ref.read(cloudFunctions),
      ref.read(firestoreProvider),
    ));

class AdminRepository {
  final FirebaseFunctions _adminCloudFunctions;
  final FirebaseFirestore _firestore;

  AdminRepository(this._adminCloudFunctions, this._firestore);

  // Professional users collection reference
  final CollectionReference<Map<String, dynamic>> _professionalUsersCollection =
      FirebaseFirestore.instance
          .collection('users')
          .doc('professionals')
          .collection('professionals');

  // admin users collection reference
  final CollectionReference<Map<String, dynamic>> _adminUsersCollection =
      FirebaseFirestore.instance
          .collection('users')
          .doc('admins')
          .collection('admins');

  // Manager users collection reference
  final CollectionReference<Map<String, dynamic>> _managerUsersCollection =
      FirebaseFirestore.instance
          .collection('users')
          .doc('managers')
          .collection('managers');

  // Create manager
  Future<Manager> createManager(
      String email, String password, String displayName) async {
    HttpsCallable callable =
        _adminCloudFunctions.httpsCallable('createManager');
    final result = await callable.call({
      'email': email,
      'password': password,
      'displayName': displayName,
    });

    //create manager user object
    final manager = Manager(
        uid: result.data['uid'],
        name: displayName,
        email: email,
        profilePic: Constants.managerImageDefault,
        role: 'manager');

    // Store manager in Firestore collection
    await _managerUsersCollection.doc(manager.uid).set(manager.toMap());
    return manager;
  }

  // Create professional
  Future<Professional> createProfessional(
    String displayName,
    String email,
    String password,
    String category,
  ) async {
    HttpsCallable callable =
        _adminCloudFunctions.httpsCallable('createProfessional');
    final result = await callable.call({
      'displayName': displayName,
      'email': email,
      'password': password,
    });

    //create Professional user object
    final professional = Professional(
      uid: result.data['uid'],
      name: displayName,
      profilePic: Constants.doctorAvatar,
      specializedIn: category,
      role: 'professional',
      email: email,
    );

    // Store professional in Firestore collection
    await _professionalUsersCollection
        .doc(professional.uid)
        .set(professional.toMap());

    return professional;
  }

  Future<Admin> createAdmin(
      String email, String password, String displayName) async {
    HttpsCallable callable = _adminCloudFunctions.httpsCallable('createAdmin');

    final result = await callable.call({
      'email': email,
      'password': password,
      'displayName': displayName,
    });

    //create admin user object
    final admin = Admin(
        uid: result.data['uid'],
        name: displayName,
        email: email,
        profilePic: Constants.adminImageDefault,
        role: 'admin');

    // Store admin in Firestore collection
    await _adminUsersCollection.doc(admin.uid).set(admin.toMap());
    return admin;
  }

  // get admin count function
  Future<int> getAdminCount() async {
    final snapshot = await _firestore
        .collection('users')
        .doc('admins')
        .collection('admins')
        .get();
    return snapshot.size;
  }

  // get Personal loggedIn User by Riverpod
}
