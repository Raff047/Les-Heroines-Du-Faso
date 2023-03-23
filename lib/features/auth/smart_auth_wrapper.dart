import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_app/core/common/widgets/error.dart';
import 'package:health_app/features/admin/screens/admin_dashboard_screen.dart';
import 'package:health_app/features/auth/screens/login.dart';
import 'package:health_app/features/manager/screens/manager_user_dashboard.dart';
import 'package:health_app/features/professionals/dashboard/professional_user_dashboard.dart';
import 'package:health_app/features/public_user/dashboard/public_user_dashboard.dart';
import 'package:health_app/models/admin_user_model.dart';
import 'package:health_app/models/manager_user_model.dart';
import 'package:health_app/models/professional_user_model.dart';
import 'package:health_app/models/public_user_model.dart';
import '../../core/common/widgets/loader.dart';
import 'controller/auth_controller.dart';

class SmartAuthWrapper extends ConsumerStatefulWidget {
  const SmartAuthWrapper({Key? key}) : super(key: key);

  @override
  ConsumerState<SmartAuthWrapper> createState() => _SmartAuthWrapperState();
}

class _SmartAuthWrapperState extends ConsumerState<SmartAuthWrapper> {
  Admin? admin;
  Manager? manager;
  Professional? professional;
  PublicUser? publicUser;

  void getAdminData(WidgetRef ref, User data) async {
    admin = await ref
        .watch(authControllerProvider.notifier)
        .adminDataStream(data.uid)
        .first;
    ref.watch(adminUserProvider.notifier).update((state) => admin);
    setState(() {});
  }

  void getProfessionalData(WidgetRef ref, User data) async {
    professional = await ref
        .watch(authControllerProvider.notifier)
        .professionalUserDataStream(data.uid)
        .first;
    ref
        .watch(professionalUserProvider.notifier)
        .update((state) => professional);
    setState(() {});
  }

  void getPublicUserData(WidgetRef ref, User data) async {
    publicUser = await ref
        .watch(authControllerProvider.notifier)
        .publicUserDataStream(data.uid)
        .first;
    ref.watch(publicUserProvider.notifier).update((state) => publicUser);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Load data from local storage
    // ref.watch(loadPublicUserLocalStorageDataProvider);
    // ref.watch(loadStaffUserLocalStorageDataProvider);

    return ref.watch(authStateChangeProvider).when(
        data: (data) {
          if (data != null) {
            // user is logged
            // determine it's role
            return ref.watch(userRoleProvider).when(
                data: (role) {
                  if (role == 'admin') {
                    getAdminData(ref, data);
                    return const AdminDashboardScreen();
                  } else if (role == 'manager') {
                    //TODO: upload data
                    return const ManagerDashboardScreen();
                  } else if (role == 'professional') {
                    getProfessionalData(ref, data);
                    return const ProfessionalDashboardScreen();
                  } else {
                    getPublicUserData(ref, data);
                    return const PublicUserDashBoardScreen();
                  }
                },
                error: (error, stackTrace) => ErrorText(
                      error: '$error',
                    ),
                loading: () => const Loader());
          } else {
            // user is not loggedIn
            return const LoginScreen();
          }
        },
        error: (error, stackTrace) {
          return Scaffold(
            body: Center(
              child: Text('$error'),
            ),
          );
        },
        loading: () => const Loader());
  }
}
