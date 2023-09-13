// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:health_app/features/auth/screens/login.dart';
import 'package:health_app/features/onboarding/screens/intro_1.dart';
import 'package:health_app/features/onboarding/screens/intro_2.dart';
import 'package:health_app/features/onboarding/screens/intro_3.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  List<Widget> screens = [
    IntroScreen2(),
    IntroScreen1(),
    IntroScreen3(),
    LoginScreen()
  ];

  // too keep track
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LiquidSwipe(
      enableLoop: false,
      pages: screens,
      slideIconWidget: Icon(Icons.arrow_back_ios_new_sharp),
    ));
  }
}
