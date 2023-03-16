import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routing/route_const.dart';
import '../../widgets/prefetch_image.dart';

class Rewards {
  final int id;
  final String name;
  final String imageUrl;
  Rewards({required this.id, required this.name, required this.imageUrl});
}

class RewardScreen extends ConsumerStatefulWidget {
  const RewardScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RewardScreenState();
}

class _RewardScreenState extends ConsumerState<RewardScreen> {
  List<Rewards> rewards = [
    Rewards(
      id: 1,
      name: "Github Education Pack",
      imageUrl: "https://img.icons8.com/3d-fluency/188/null/github.png",
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Semantics(
      attributedHint: AttributedString("Home Screen"),
      label: "Home Screen",
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Rewards",
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: rewards.length,
                    itemBuilder: (context, index) {
                      final reward = rewards[index];
                      return InkWell(
                        onTap: () {
                          if (reward.id == 1) {
                            GoRouter.of(context)
                                .push(RouteNames.googleOpinionRewardScreen);
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
                                      imageUrl: reward.imageUrl,
                                      height: 70,
                                      width: 70),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    reward.name,
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
