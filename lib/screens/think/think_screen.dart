import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/prefetch_image.dart';
import '../../widgets/traingle_painter.dart';

class ThinkModel {
  final int id;
  final String name;
  final String description;
  String imageUrl;
  ThinkModel(
      {required this.id,
      required this.name,
      required this.description,
      required this.imageUrl});
}

class ThinkScreen extends ConsumerStatefulWidget {
  const ThinkScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ThinkScreenState();
}

class _ThinkScreenState extends ConsumerState<ThinkScreen> {
  final storage = FirebaseStorage.instance.ref("brain_storming.png");
  List<ThinkModel> thinkList = [
    ThinkModel(
      id: 1,
      name: "Brain Storming",
      description: "Discover your hidden potential",
      imageUrl: "",
    )
  ];

  @override
  void initState() {
    super.initState();
    storage.getDownloadURL().then((value) => {
          setState(() {
            thinkList[0].imageUrl = value;
          })
        });
  }

  // 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
  @override
  Widget build(BuildContext context) {
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
                  height: 30,
                ),
                Expanded(
                  child: GridView.builder(
                    restorationId: "think_grid",
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      mainAxisExtent: 150,
                    ),
                    itemCount: thinkList.length,
                    itemBuilder: (context, index) {
                      final think = thinkList[index];
                      return InkWell(
                        onTap: () {
                          switch (think.id) {
                            case 1:

                            case 2:
                              break;
                          }
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.centerRight,
                          fit: StackFit.expand,
                          children: [
                            Card(
                              shadowColor: Colors.white,
                              color: Colors.lightGreenAccent,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(60),
                                ),
                              ),
                              elevation: 3,
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(60),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const SizedBox(
                                        height: 40,
                                      ),
                                      Text(
                                        think.name,
                                        style: GoogleFonts.roboto(
                                          fontSize: 25,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        think.description,
                                        style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              top: -4,
                              left: 10,
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 8.0,
                                      width: 5.0,
                                      child: CustomPaint(
                                        painter: TrianglePainter(),
                                      ),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(6.0),
                                              bottomLeft:
                                                  Radius.circular(6.0))),
                                      width: 120.0,
                                      height: 30.0,
                                      child: const Center(
                                        child: Text(
                                          'Coming Soon',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned.fill(
                              top: -50,
                              right: 10,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: PrefetchImage(
                                  imageUrl: think.imageUrl,
                                  height: 100,
                                  width: 100,
                                ),
                              ),
                            )
                          ],
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
