import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:one_crore_project/routing/route_const.dart';
import 'package:one_crore_project/util/launch_url.dart';

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
    Rewards(
      id: 2,
      name: "Z Library - Free E-Books",
      imageUrl:
          "https://techdator.net/wp-content/uploads/2022/05/Z-Library-Alternatives.png",
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
                  style: GoogleFonts.robotoFlex(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Expanded(
                  child: GridView.builder(
                    restorationId: "reward_grid",
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisExtent: 140,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: rewards.length,
                    itemBuilder: (context, index) {
                      final reward = rewards[index];
                      return InkWell(
                        onTap: () {
                          switch (reward.id) {
                            case 1:
                              context
                                  .push(RouteNames.githubEducationPackScreen);
                              break;
                            case 2:
                              LaunchUrl.launch(
                                  "https://lib-x4xkmg3vnptikfooshgpe3tb.1lib.cz/");
                              break;
                          }
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Card(
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
                                      const SizedBox(
                                        height: 40,
                                      ),
                                      Text(
                                        reward.name,
                                        style: GoogleFonts.robotoFlex(
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
                            Positioned.fill(
                              top: -30,
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: PrefetchImage(
                                    imageUrl: reward.imageUrl,
                                    height: 70,
                                    width: 70),
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
