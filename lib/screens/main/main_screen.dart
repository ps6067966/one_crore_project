import 'dart:developer';

import 'package:bottom_bar_matu/bottom_bar_matu.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_crore_project/screens/home/home_screen.dart';
import 'package:one_crore_project/screens/notification/notification_screen.dart';
import 'package:one_crore_project/screens/profile/profile_screen.dart';
import 'package:one_crore_project/screens/reward/reward_screen.dart';
import 'package:one_crore_project/screens/think/think_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  final int? index;
  const MainScreen({this.index, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int selectedIndex = 0;
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  Widget page() {
    switch (selectedIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const RewardScreen();
      case 2:
        return const ThinkScreen();
      case 3:
        return const NotificationScreen();

      case 4:
        return const ProfileScreen();
      default:
        return const ProfileScreen();
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.index != null) {
      selectedIndex = widget.index!;
    }
  }

  @override
  Widget build(BuildContext context) {
    log("Main Screen");

    return Scaffold(
      bottomNavigationBar: BottomBarDoubleBullet(
        selectedIndex: selectedIndex,
        backgroundColor: Colors.black54,
        items: [
          BottomBarItem(iconData: Icons.home),
          BottomBarItem(iconData: Icons.redeem),
          BottomBarItem(
            iconData: Icons.psychology_alt_rounded,
          ),
          BottomBarItem(iconData: Icons.notifications),
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
