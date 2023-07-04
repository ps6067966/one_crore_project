import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:one_crore_project/constant/color.dart';
import 'package:one_crore_project/screens/feed/educational_videos.dart';
import 'package:one_crore_project/screens/feed/motivational_videos.dart';
import 'package:one_crore_project/util/utils.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final PageController controller = PageController();
  int selectedIndex = 0;

  void _toggleSelection(int index) {
    controller.animateToPage(index,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        centerTitle: false,
        titleSpacing: 0,
        backgroundColor: context.isDarkMode ? null : Colors.white,
        title: Text(
          "Community Feed",
          style: GoogleFonts.oswald().copyWith(),
        ),
        elevation: 0,
      ),
      backgroundColor: context.isDarkMode ? null : Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.amber,
                    width: 2,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(35)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: selectedIndex == 0
                                ? primaryColor
                                : Colors.transparent,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25)),
                          ),
                          child: Center(
                            child: Text(
                              "Educational",
                              style: TextStyle(
                                color: selectedIndex == 0
                                    ? Colors.white
                                    : context.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: selectedIndex == 1
                                ? primaryColor
                                : Colors.transparent,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25)),
                          ),
                          child: Center(
                            child: Text(
                              "Motivational",
                              style: TextStyle(
                                color: selectedIndex == 1
                                    ? Colors.white
                                    : context.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: controller,
                onPageChanged: (value) {
                  if (mounted) {
                    setState(() {
                      selectedIndex = value;
                    });
                  }
                },
                children: const [
                  EducationVideos(),
                  MotivationalVideos(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
