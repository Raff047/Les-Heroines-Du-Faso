// // ignore_for_file: prefer_const_constructors

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:health_app/features/admin/screens/admin_dashboard_screen.dart';
// import 'package:health_app/features/auth/controller/auth_controller.dart';
// import 'package:health_app/features/auth/repository/auth_repository.dart';
// import 'package:health_app/features/manager/screens/manager_user_dashboard.dart';
// import 'package:health_app/features/onboarding/screens/onboarding_screen.dart';
// import 'package:health_app/features/professionals/screens/professional_user_dashboard.dart';
// import 'package:health_app/features/public_users_feature/screens/public_user_dashboard.dart';
// import 'package:health_app/models/public_user_model.dart';

// class AuthWrapper extends ConsumerWidget {
//   const AuthWrapper({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       body: FutureBuilder<User?>(
//         future: ref.read(authRepositoryProvider).getCurrentPersonalUser(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             // Show a loading indicator while waiting for the data
//             return CircularProgressIndicator(
//               color: Colors.pink.shade300,
//             );
//           } else if (snapshot.hasError) {
//             // Show an error message if the data failed to load
//             return Text('Error: ${snapshot.error}');
//           } else {
//             final user = snapshot.data;
//             if (user != null) {
//               return FutureBuilder<IdTokenResult>(
//                 future: user.getIdTokenResult(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     // Show a loading indicator while waiting for the data
//                     return CircularProgressIndicator(
//                       color: Colors.pink,
//                     );
//                   } else if (snapshot.hasError) {
//                     // Show an error message if the data failed to load
//                     return Text('Error: ${snapshot.error}');
//                   } else {
//                     final idTokenResult = snapshot.data;
//                     if (idTokenResult != null) {
//                       if (idTokenResult.claims!['role'] == 'manager') {
//                         // user is a manager
//                         return ManagerDashboardScreen();
//                       } else if (idTokenResult.claims!['role'] ==
//                           'professional') {
//                         // user is a professional
//                         return ProfessionalDashboardScreen();
//                       } else if (idTokenResult.claims!['role'] == 'admin') {
//                         // user is admin
//                         return AdminDashboardScreen();
//                       }
//                     }
//                   }
//                   // By default, return the public home screen
//                   return FutureBuilder<PublicUserModel?>(
//                     future: ref
//                         .watch(authControllerProvider)
//                         .getCurrentPublicUserData(),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return CircularProgressIndicator(
//                           color: Colors.pink,
//                         );
//                       } else if (snapshot.hasError) {
//                         return Text('Error: ${snapshot.error}');
//                       } else {
//                         return PublicUserDashBoardScreen();
//                       }
//                     },
//                   );
//                 },
//               );
//             } else {
//               // If the user is not logged in, return the welcome screen
//               return OnboardingScreen();
//             }
//           }
//         },
//       ),
//     );
//   }
// }
