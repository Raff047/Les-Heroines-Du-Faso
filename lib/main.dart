// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:health_app/theme/pallete.dart';
import 'features/auth/smart_auth_wrapper.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        theme: Pallete.darkModeAppTheme,
        debugShowCheckedModeBanner: false,
        title: 'womens health',
        home: SmartAuthWrapper());
  }
}
