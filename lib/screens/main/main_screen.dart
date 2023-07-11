import 'package:bottom_bar_matu/bottom_bar_matu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_crore_project/constant/color.dart';
import 'package:one_crore_project/screens/feed/feed_screen.dart';
import 'package:one_crore_project/screens/home/home_screen.dart';
import 'package:one_crore_project/screens/profile/profile_screen.dart';
import 'package:one_crore_project/screens/reward/reward_screen.dart';
import 'package:one_crore_project/screens/think/think_screen.dart';
import 'package:one_crore_project/util/utils.dart';

import '../../services/firebase_messaging.dart';
import '../../util/check_update.dart';

class MainScreen extends ConsumerStatefulWidget {
  final int? index;
  const MainScreen({this.index, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int selectedIndex = 2;

  Widget page() {
    switch (selectedIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const RewardScreen();
      case 2:
        return const FeedScreen();
      case 3:
        return const ThinkScreen();
      case 4:
        return const ProfileScreen();
      default:
        return const ProfileScreen();
    }
  }

  @override
  void initState() {
    super.initState();
    UpdateChecker.checkForUpdate();
    if (widget.index != null) {
      selectedIndex = widget.index!;
    }
    FirebaseMessagingService.handleBackgroudFirebaseMessaging();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomBarDoubleBullet(
        selectedIndex: selectedIndex,
        backgroundColor:
            context.isDarkMode ? primaryBlackColor : Colors.grey.shade200,
        items: [
          BottomBarItem(iconData: Icons.home),
          BottomBarItem(iconData: Icons.redeem),
          BottomBarItem(iconData: CupertinoIcons.rocket_fill),
          BottomBarItem(
            iconData: Icons.psychology_alt_rounded,
          ),
          BottomBarItem(iconData: Icons.person_4_rounded),
        ],
        onSelect: (index) {
          if (mounted) {
            setState(() {
              selectedIndex = index;
            });
          }
        },
      ),
      body: page(),
    );
  }
}
