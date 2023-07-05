import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:one_crore_project/util/utils.dart';
import 'package:one_crore_project/widgets/progress_container_view.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../constant/color.dart';

final wisdomCollection = FirebaseFirestore.instance.collection("wisdom");

class AddWisdomScreen extends ConsumerStatefulWidget {
  const AddWisdomScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddWisdomScreenState();
}

class _AddWisdomScreenState extends ConsumerState<AddWisdomScreen> {
  final TextEditingController _wisdomQuotesController = TextEditingController();
  bool isProgressRunning = false;
  User? currentUser = FirebaseAuth.instance.currentUser;
  List<String> language = ["Hindi", "English"];
  String selectedLanguage = "English";

  addWisdom() async {
    if (mounted) {
      setState(() {
        isProgressRunning = true;
      });
    }
    try {
      final docRef =
          await wisdomCollection.orderBy("id", descending: true).limit(1).get();
      final docId = docRef.docs.first.data()['id'];

      await wisdomCollection.doc().set(
        {
          "id": docId + 1,
          "wisdom": _wisdomQuotesController.text,
          "name": currentUser?.displayName,
          "email": currentUser?.email,
          "photo_url": currentUser?.photoURL,
          "lang": selectedLanguage,
          "timestamp": DateTime.now().toIso8601String(),
        },
      );
      _wisdomQuotesController.clear();

      if (mounted) {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.success(
            message: "Wisdom Added Successfully",
            messagePadding:
                EdgeInsets.only(left: 75, right: 8, top: 12, bottom: 12),
          ),
        );
        GoRouter.of(context).pop();
      }
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.isDarkMode ? null : Colors.grey[200],
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: ProgressContainerView(
        isProgressRunning: isProgressRunning,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
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
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: primaryBlackColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Add Wisdom",
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        color: context.isDarkMode
                            ? primaryBlackColor
                            : Colors.white,
                        surfaceTintColor: Colors.white,
                        shadowColor:
                            context.isDarkMode ? Colors.white : primaryColor,
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Creative Writing -->",
                                style: TextStyle(fontSize: 18),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              TextFormField(
                                controller: _wisdomQuotesController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText:
                                      "What's in your mind? Take a deep breath and share your wisdom with the world. Creativity, Innovation starts with sharing...",
                                ),
                                minLines: 5,
                                maxLines: 5,
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              const Text(
                                "Language -->",
                                style: TextStyle(fontSize: 18),
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
                              const SizedBox(
                                height: 16,
                              ),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    addWisdom();
                                  },
                                  child: const Text("Add Wisdom"),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
