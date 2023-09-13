// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:health_app/core/common/repositories/common_firebase_storage_methods.dart';
import 'package:health_app/core/failure.dart';
import 'package:health_app/core/providers/firebase_providers.dart';
import 'package:health_app/core/type_defs.dart';
import 'package:health_app/features/auth/screens/otp_screen.dart';
import 'package:health_app/features/public_user/dashboard/public_user_dashboard.dart';
import 'package:health_app/models/professional_user_model.dart';
import 'package:health_app/models/public_user_model.dart';
import 'package:health_app/models/user_base_model_class.dart';
import '../../../core/common/widgets/show_snack_bar.dart';
import '../../../core/constants/constants.dart';
import '../../../models/admin_user_model.dart';
import '../../../models/manager_user_model.dart';
import '../screens/registration.dart';

// AuthRepository Provider
final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    ref.read(firestoreProvider),
    ref.read(authProvider),
  ),
);

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  AuthRepository(this._firestore, this._auth);

  // stream authStateChange
  Stream<User?> get authStateChange => _auth.authStateChanges();

  // public users collection reference
  final CollectionReference<Map<String, dynamic>> _publicUsersCollection =
      FirebaseFirestore.instance
          .collection('users')
          .doc('publicUsers')
          .collection('publicUsers');

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

  // return user IdToken
  Future<String> getUserRole() async {
    final User? user =
        await _auth.authStateChanges().first.then((value) => value);
    final String role =
        await user!.getIdTokenResult().then((value) => value.claims!['role']);
    return role;
  }

//Login with email and password -- PERSONALS ONLY --
  FutureEither<UserModel?> signInForOthersWithEmail(
      BuildContext context, String? email, String? password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email!, password: password!);
      // Get custom claims to determine user role
      // final role = await getUserRole();
      final role = await userCredential.user!
          .getIdTokenResult()
          .then((value) => value.claims!['role']);

      // Retrieve user data from Firestore based on user role
      if (role == 'professional') {
        final professional =
            await professionalUserDataStream(userCredential.user!.uid).first;
        return right(professional);
      } else if (role == 'manager') {
        final manager = await managerDataStream(userCredential.user!.uid).first;
        return right(manager);
      } else if (role == 'admin') {
        final admin = await adminDataStream(userCredential.user!.uid).first;
        return right(admin);
      } else {
        throw 'Unknown error';
      }
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //signin with phone number method -- PUBLIC USER ONLY
  FutureVoid signInWithPhoneNumber(
      {required BuildContext context, required String phoneNumber}) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted:
            (PhoneAuthCredential phoneAuthCredential) async =>
                await _auth.signInWithCredential(phoneAuthCredential),
        verificationFailed: (e) => throw Exception(e.message),
        codeSent: (verificationId, forceResendingToken) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) =>
                      OtpScreen(verificationId: verificationId))));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
      return right(Void);
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //verify otp method
  FutureEither<PublicUser> verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
    // add onSuccess method to show we have a valid users
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOTP,
      );
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final validUser = userCredential.user;

      // check whether validUser exists or is newUser
      if (await checkExistingUser(validUser!.uid)) {
        // user exists
        // get user data from db
        final publicUser = await publicUserDataStream(validUser.uid).first;

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: ((context) => PublicUserDashBoardScreen())),
            (route) => false);

        return right(publicUser);
      } else {
        //user is new
        final newUser = userCredential.user;
        final newPublicUser = PublicUser(
            uid: newUser!.uid,
            name: '',
            profilePic: Constants.avatarDefault,
            phoneNumber: newUser.phoneNumber!,
            role: 'public user');

        //push user to registration screen & store his data
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: ((context) => RegistrationScreen())),
            (route) => false);
        return right(newPublicUser);
      }
    } on FirebaseAuthException catch (e) {
      throw e.toString();
    } catch (e) {
      return left(Failure('error " $e'));
    }
  }

  // Stream of PublicUser Data
  Stream<PublicUser> publicUserDataStream(String uid) {
    return _publicUsersCollection.doc(uid).snapshots().map(
        (event) => PublicUser.fromMap(event.data() as Map<String, dynamic>));
  }

  // Stream of Professional Data
  Stream<Professional> professionalUserDataStream(String uid) {
    return _professionalUsersCollection.doc(uid).snapshots().map(
        (event) => Professional.fromMap(event.data() as Map<String, dynamic>));
  }

  // Stream of Manager Data
  Stream<Manager> managerDataStream(String uid) {
    return _managerUsersCollection
        .doc(uid)
        .snapshots()
        .map((event) => Manager.fromMap(event.data() as Map<String, dynamic>));
  }

  // Stream of Admin Data
  Stream<Admin> adminDataStream(String uid) {
    return _adminUsersCollection
        .doc(uid)
        .snapshots()
        .map((event) => Admin.fromMap(event.data() as Map<String, dynamic>));
  }

  // check existing PublicUser.
  Future<bool> checkExistingUser(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('users')
        .doc('publicUsers')
        .collection('publicUsers')
        .doc(uid)
        .get();

    if (snapshot.exists) {
      return true;
    } else {
      return false;
    }
  }

  // save public user data to firestore
  void saveUserDataToFirestore({
    required String name,
    required File? profilePic,
    required Ref ref,
    required BuildContext context,
  }) async {
    try {
      String uid = _auth.currentUser!.uid;
      String photoUrl = Constants.avatarDefault;

      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageMethodsProvider)
            .storeFileToFirebase('profilePic/$uid', profilePic);
      }

      var user = PublicUser(
          uid: uid,
          name: name,
          phoneNumber: _auth.currentUser!.phoneNumber!,
          profilePic: photoUrl,
          role: 'public user');

      await _publicUsersCollection.doc(uid).set(user.toMap());

      // push Public user to publicUserScreen
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: ((context) => PublicUserDashBoardScreen())),
          (route) => false);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  //sign out
  void signUserOut() {
    print('${_auth.currentUser?.uid} has signed out');
    _auth.signOut();
  }
}
