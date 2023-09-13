// ignore_for_file: prefer_const_constructors

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:health_app/features/manager/profile_settings/profile_settings.dart';
import 'package:health_app/theme/pallete.dart';
import '../articles/screens/explore_articles.dart';
import '../community/screens/community_main.dart';

class ManagerDashboardScreen extends StatefulWidget {
  const ManagerDashboardScreen({super.key});

  @override
  State<ManagerDashboardScreen> createState() => _ManagerDashboardScreenState();
}

class _ManagerDashboardScreenState extends State<ManagerDashboardScreen> {
  // Bottom nav icons
  final navIcons = [
    Icon(Icons.article),
    Icon(Icons.people),
    Icon(Icons.account_circle)
  ];

  int index = 1;
  @override
  Widget build(BuildContext context) {
    Widget getSelectedScreen({required int index}) {
      Widget screen;
      switch (index) {
        case 0:
          screen = ManagerExploreArticlesScreen();
          break;
        case 1:
          screen = ManagerCommunityMainScreen();
          break;
        default:
          screen = ManagerProfileSettingsScreen();
      }
      // return screen;
      return screen;
    }

    return Scaffold(
        extendBodyBehindAppBar: true,
        body: getSelectedScreen(index: index),
        bottomNavigationBar: CurvedNavigationBar(
          color: Pallete.greenColor,
          backgroundColor: Pallete.blackColor,
          height: MediaQuery.of(context).size.height * .067,
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
