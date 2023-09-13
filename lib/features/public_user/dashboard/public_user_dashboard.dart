import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_app/features/public_user/chat/screens/chat.dart';
import 'package:health_app/features/public_user/articles/screens/explore_articles.dart';
import 'package:health_app/features/public_user/community/screens/community_main.dart';
import 'package:health_app/features/public_user/period_tracker/screens/period_tracker.dart';
import 'package:health_app/theme/pallete.dart';
import '../profile_settings/profile_settings.dart';

class PublicUserDashBoardScreen extends ConsumerStatefulWidget {
  const PublicUserDashBoardScreen({
    super.key,
  });

  @override
  ConsumerState<PublicUserDashBoardScreen> createState() =>
      _PublicUserDashboardScreenState();
}

class _PublicUserDashboardScreenState
    extends ConsumerState<PublicUserDashBoardScreen> {
  // Bottom nav icons
  final navIcons = const [
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
          screen = const PeriodTracker();
          break;
        case 1:
          screen = const ExploreArticles();
          break;
        case 2:
          screen = const PublicUserCommunityMainScreen();
          break;
        case 3:
          screen = const MainChatScreen();
          break;
        default:
          screen = const PublicUserProfileSettings();
      }
      return screen;
    }

    return Scaffold(
        extendBodyBehindAppBar: true,
        body: getSelectedScreen(index: index),
        bottomNavigationBar: CurvedNavigationBar(
          height: 60,
          color: Pallete.greenColor,
          animationDuration: const Duration(milliseconds: 300),
          backgroundColor: Pallete.blackColor,
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
