import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:one_crore_project/constant/color.dart';
import 'package:one_crore_project/routing/route_const.dart';
import 'package:one_crore_project/screens/feed/ai_videos.dart';
import 'package:one_crore_project/screens/feed/coding_videos.dart';
import 'package:one_crore_project/screens/feed/educational_videos.dart';
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
      backgroundColor: context.isDarkMode ? null : Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(RouteNames.addFeedScreen);
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Community Feed",
                style: GoogleFonts.robotoFlex(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  height: 60,
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
                        flex: selectedIndex == 0 ? 2 : 1,
                        child: InkWell(
                          onTap: () {
                            _toggleSelection(0);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
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
                                    fontSize: 12,
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
                      ),
                      Expanded(
                        flex: selectedIndex == 1 ? 2 : 1,
                        child: InkWell(
                          onTap: () {
                            _toggleSelection(1);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
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
                                  "AI",
                                  style: TextStyle(
                                    fontSize: 12,
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
                      ),
                      Expanded(
                        flex: selectedIndex == 2 ? 2 : 1,
                        child: InkWell(
                          onTap: () {
                            _toggleSelection(2);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: selectedIndex == 2
                                    ? primaryColor
                                    : Colors.transparent,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(25)),
                              ),
                              child: Center(
                                child: Text(
                                  "Coding",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: selectedIndex == 2
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
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
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
                    AiVideos(),
                    CodingVideos(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
