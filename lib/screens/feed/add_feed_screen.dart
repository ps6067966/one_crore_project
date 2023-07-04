import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:one_crore_project/constant/color.dart';
import 'package:one_crore_project/screens/feed/educational_videos.dart';
import 'package:one_crore_project/widgets/pod_players.dart';
import 'package:one_crore_project/widgets/progress_container_view.dart';

class AddFeedScreen extends ConsumerStatefulWidget {
  const AddFeedScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddFeedScreenState();
}

class _AddFeedScreenState extends ConsumerState<AddFeedScreen> {
  List<String> categories = [
    "Educational",
    "AI",
    "Coding",
  ];
  List<String> language = ["Hindi", "English"];
  final TextEditingController _videoUrlcontroller = TextEditingController();
  String selectedCategory = "Educational";
  String selectedLanguage = "English";
  bool isProgressRunning = false;

  addVideo() async {
    if (mounted) {
      setState(() {
        isProgressRunning = true;
      });
    }
    try {
      final docRef =
          await videoCollection.orderBy("id", descending: true).limit(1).get();
      final docId = docRef.docs.first.data()['id'];

      await videoCollection.doc().set({
        "id": docId + 1,
        "url": _videoUrlcontroller.text,
        "type": selectedCategory,
        "lang": selectedLanguage,
        "timestamp": DateTime.now().toIso8601String(),
      });
      _videoUrlcontroller.clear();
    } catch (e) {
      log("$e");
    }
    if (mounted) {
      setState(() {
        isProgressRunning = false;
      });
    }
  }

  @override
  void dispose() {
    _videoUrlcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: ProgressContainerView(
        isProgressRunning: isProgressRunning,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          context.pop();
                        },
                        icon: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.only(right: 2.0),
                              child: Icon(Icons.arrow_back_ios_new),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Add Video",
                        style: GoogleFonts.robotoFlex(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    "Hii, Guys! Share the video with the world that you feel/think worth sharing, Just paste the video url of Youtube.",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Card(
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    shadowColor: primaryColor,
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          const Text(
                            "Video URL ->",
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: _videoUrlcontroller,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Enter video url",
                            ),
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            "Video Category ->",
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          DropdownButtonFormField(
                            value: selectedCategory,
                            items: categories
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Select video category",
                            ),
                            onChanged: (value) {
                              setState(() {
                                selectedCategory = value.toString();
                              });
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            "Video Language ->",
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          DropdownButtonFormField(
                            value: selectedLanguage,
                            items: language
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Select video category",
                            ),
                            onChanged: (value) {
                              setState(() {
                                selectedLanguage = value.toString();
                              });
                            },
                          ),
                          _videoUrlcontroller.text.trim().isNotEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    const Text(
                                      "Video Preview ->",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    PodPlayerView(
                                        videoUrl:
                                            _videoUrlcontroller.text.trim())
                                  ],
                                )
                              : const SizedBox(),
                          const SizedBox(
                            height: 16,
                          ),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                addVideo();
                              },
                              child: const Text("Add Video"),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
