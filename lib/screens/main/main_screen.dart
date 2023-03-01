import 'package:bottom_bar_matu/bottom_bar_matu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_crore_project/screens/calender/calender_screen.dart';
import 'package:one_crore_project/screens/chat/chat_screen.dart';
import 'package:one_crore_project/screens/home/home_screen.dart';
import 'package:one_crore_project/screens/notification/notification_screen.dart';
import 'package:one_crore_project/screens/profile/profile_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int selectedIndex = 0;

  Widget page() {
    switch (selectedIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const ChatScreen();
      case 2:
        return const NotificationScreen();
      case 3:
        return const CalenderScreen();
      case 4:
        return const ProfileScreen();
      default:
        return const ProfileScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomBarDoubleBullet(
        selectedIndex: selectedIndex,
        items: [
          BottomBarItem(iconData: Icons.home),
          BottomBarItem(iconData: Icons.chat),
          BottomBarItem(iconData: Icons.notifications),
          BottomBarItem(iconData: Icons.calendar_month),
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
