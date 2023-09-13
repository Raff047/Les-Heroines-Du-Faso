// ignore_for_file: prefer_const_constructors

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:health_app/features/professionals/chat/screens/chat.dart';
import 'package:health_app/features/professionals/community/screens/community_main.dart';
import 'package:health_app/theme/pallete.dart';
import '../articles/screens/explore_articles.dart';
import '../period_tracker/screens/professional_period_tracker.dart';
import '../profile_settings/professiona_profile_settings.dart';

class ProfessionalDashboardScreen extends StatefulWidget {
  const ProfessionalDashboardScreen({super.key});

  @override
  State<ProfessionalDashboardScreen> createState() =>
      _ProfessionalDashboardScreenState();
}

class _ProfessionalDashboardScreenState
    extends State<ProfessionalDashboardScreen> {
  // Bottom nav icons
  final navIcons = [
    Icon(Icons.calendar_month),
    Icon(Icons.article),
    Icon(Icons.people),
    Icon(Icons.chat_bubble),
    Icon(Icons.account_circle)
  ];

  int index = 1;
  @override
  Widget build(BuildContext context) {
    Widget getSelectedScreen({required int index}) {
      Widget screen;
      switch (index) {
        case 0:
          screen = const ProfessionalPeriodTrackerScreen();
          break;
        case 1:
          screen = ProfessionalExploreArticlesScreen();
          break;
        case 2:
          screen = ProfessionalCommunityMainScreen();
          break;
        case 3:
          screen = ProfessionalsChatScreen(); //ProfessionalStartChatScreen()
          break;
        default:
          screen = ProfessionalUserProfileSettings();
      }
      // return screen;
      return screen;
    }

    return Scaffold(
        // backgroundColor: const Color(0xffFCFFE7),
        extendBodyBehindAppBar: true,
        body: getSelectedScreen(index: index),
        bottomNavigationBar: CurvedNavigationBar(
          color: Pallete.greenColor,
          backgroundColor: Pallete.blackColor,
          height: 60,
          animationDuration: Duration(milliseconds: 300),
          items: navIcons,
          index: index,
          onTap: (selectedIndex) {
            setState(() {
              index = selectedIndex;
            });
          },
        ));
  }
}
