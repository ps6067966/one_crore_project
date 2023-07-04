import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_crore_project/util/utils.dart';

class MotivationalVideos extends ConsumerStatefulWidget {
  const MotivationalVideos({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MotivationalVideosState();
}

class _MotivationalVideosState extends ConsumerState<MotivationalVideos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.isDarkMode ? null : Colors.white,
      body: const Center(
        child: Column(
          children: [
            Text("Motivational Content"),
          ],
        ),
      ),
    );
  }
}
