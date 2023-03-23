import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:health_app/core/failure.dart';
import 'package:health_app/features/auth/repository/auth_repository.dart';
import 'package:health_app/models/professional_user_model.dart';
import 'package:health_app/models/public_user_model.dart';
import 'package:health_app/models/user_base_model_class.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/common/widgets/show_snack_bar.dart';
import '../../../models/admin_user_model.dart';
import '../../../models/manager_user_model.dart';

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    ref.watch(authRepositoryProvider),
    ref,
  ),
);

// localStorageDataProvider FOR staffUser
// final loadStaffUserLocalStorageDataProvider = FutureProvider((ref) {
//   final authController = ref.watch(authControllerProvider.notifier);
//   return authController.loadUserData();
// });

// localStorageDataProvider for Public Users
// final loadPublicUserLocalStorageDataProvider = FutureProvider((ref) {
//   final authController = ref.watch(authControllerProvider.notifier);
//   return authController.loadPublicUserData();
// });

// authStateChange Stream Provider
final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

// Public User Provider
final publicUserProvider = StateProvider<PublicUser?>((ref) => null);

// professional Provider
final professionalUserProvider = StateProvider<Professional?>((ref) => null);
// admin Provider
final adminUserProvider = StateProvider<Admin?>((ref) => null);
// manager Provider
final managerUserProvider = StateProvider<Manager?>((ref) => null);

// Public User Data Stream Provider
final publicUserDataStreamProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.publicUserDataStream(uid);
});

// Professional User Data Stream Provider
final professionalUserDataStreamProvider =
    StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.professionalUserDataStream(uid);
});

// Manager User Data Stream Provider
final managerUserDataStreamProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.managerDataStream(uid);
});

// Admin User Data Stream Provider
final adminUserDataStreamProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.adminDataStream(uid);
});

// user role provider
final userRoleProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserRole();
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref ref;

  AuthController(
    this._authRepository,
    this.ref,
  ) : super(false); // Loading

  //get authStateChange stream
  Stream<User?> get authStateChange => _authRepository.authStateChange;

  //get public User Data stream
  Stream<PublicUser> publicUserDataStream(String uid) {
    return _authRepository.publicUserDataStream(uid);
  }

  //get Professional USer Data stream
  Stream<Professional> professionalUserDataStream(String uid) {
    return _authRepository.professionalUserDataStream(uid);
  }

  //get Manager USer Data stream
  Stream<Manager> managerDataStream(String uid) {
    return _authRepository.managerDataStream(uid);
  }

  //get Admin USer Data stream
  Stream<Admin> adminDataStream(String uid) {
    return _authRepository.adminDataStream(uid);
  }

  //SIGN IN WITH EMAIL -- SHARED PREFERENCES ADDED
  Future<Either<Failure, UserModel?>> signInForOthersWithEmail(
      BuildContext context, String? email, String? password) async {
    // Sign in with email and password
    final result = await _authRepository.signInForOthersWithEmail(
        context, email, password);
    // Handle user role in result
    await result.fold((l) {
      showSnackBar(context: context, content: l.message);
    }, (userModel) async {
      // Save user data to shared preferences
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.setString('userType', staffUser.runtimeType.toString());
      // await prefs.setString('userData', json.encode(staffUser?.toJson()));
      // Update provider state with user data
      if (userModel is Professional) {
        print(' authController : ${userModel.name}');
        ref
            .watch(professionalUserProvider.notifier)
            .update((state) => userModel);
        ref.refresh(userRoleProvider);
      } else if (userModel is Manager) {
        ref.refresh(userRoleProvider);
        ref.watch(managerUserProvider.notifier).update((state) => userModel);
      } else if (userModel is Admin) {
        ref.refresh(userRoleProvider);
        ref.watch(adminUserProvider.notifier).update((state) => userModel);
      }
    });
    return result;
  }

  //sign in with phone number method
  void signInWithPhoneNumber(
      {BuildContext? context, String? phoneNumber}) async {
    state = true;
    final user = await _authRepository.signInWithPhoneNumber(
        context: context!, phoneNumber: phoneNumber!);
    state = false;
    user.fold(
        (l) => showSnackBar(context: context, content: l.message), (r) => null);
  }

// verify OTP method
  void verifyOTP(
      BuildContext context, String verificationId, String userOTP) async {
    final user = await _authRepository.verifyOTP(
      context: context,
      verificationId: verificationId,
      userOTP: userOTP,
    );

    user.fold(
        (failure) => showSnackBar(context: context, content: failure.message),
        (publicUser) async {
      // Save userId to SharedPreferences
      // final prefs = await SharedPreferences.getInstance();
      // json.encode(staffUser?.toJson()));
      // await prefs.setString('publicUserId', json.encode(publicUser.toJson()));
      ref.watch(publicUserProvider.notifier).update((state) => publicUser);
    });
  }

  //save user data to firestore
  void saveUserDataToFirestore(
    BuildContext context,
    String name,
    File? profilePic,
  ) {
    _authRepository.saveUserDataToFirestore(
        name: name, profilePic: profilePic, ref: ref, context: context);
  }

  //get current user data
  Future<String> getUserRole() async {
    return await _authRepository.getUserRole();
  }

  //sign out method
  void signUserOut() {
    _authRepository.signUserOut();
  }
}
