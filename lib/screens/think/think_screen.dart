import 'package:awesome_snackbar_content_new/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/prefetch_image.dart';

class ThinkModel {
  final int id;
  final String name;
  final String imageUrl;
  ThinkModel({required this.id, required this.name, required this.imageUrl});
}

class ThinkScreen extends ConsumerStatefulWidget {
  const ThinkScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ThinkScreenState();
}

class _ThinkScreenState extends ConsumerState<ThinkScreen> {
  List<ThinkModel> thinkList = [
    ThinkModel(
        id: 1,
        name: "Chat GPT - AI Chatbot",
        imageUrl:
            "https://upload.wikimedia.org/wikipedia/commons/0/04/ChatGPT_logo.svg"),
  ];

  // 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
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Semantics(
      attributedHint: AttributedString("Think Screen"),
      label: "Think Screen",
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Think",
                  style: GoogleFonts.roboto(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: GridView.builder(
                    restorationId: "think_grid",
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: thinkList.length,
                    itemBuilder: (context, index) {
                      final think = thinkList[index];
                      return InkWell(
                        onTap: () {
                          switch (think.id) {
                            case 1:
                              final snackBar = SnackBar(
                                elevation: 2,
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,
                                content: AwesomeSnackbarContent(
                                  title: "Chat GPT is not available yet",
                                  message: "",
                                  inMaterialBanner: true,
                                  contentType: ContentType.failure,
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              break;
                            case 2:
                              break;
                          }
                        },
                        child: Card(
                          elevation: 5,
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  PrefetchImage(
                                      imageUrl: think.imageUrl,
                                      height: 70,
                                      width: 70),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    think.name,
                                    style: GoogleFonts.roboto(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
