import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_crore_project/util/utils.dart';

class EducationVideos extends ConsumerStatefulWidget {
  const EducationVideos({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EducationVideosState();
}

class _EducationVideosState extends ConsumerState<EducationVideos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.isDarkMode ? null : Colors.white,
      body: const Column(
        children: [
          Text("Educational Content"),
        ],
      ),
    );
  }
}
