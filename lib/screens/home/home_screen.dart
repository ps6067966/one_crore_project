import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routing/route_const.dart';
import '../../util/check_update.dart';

class Services {
  final int id;
  final String name;
  final String imageUrl;
  Services({required this.id, required this.name, required this.imageUrl});
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  List<Services> serviceList = [
    Services(
        id: 1,
        name: "Google Opinion Rewards",
        imageUrl:
            "https://upload.wikimedia.org/wikipedia/commons/b/b1/Google_Opinion_Rewards_app_logo.png"),
    Services(
      id: 2,
      name: "AI Chat Bot\n2.0",
      imageUrl:
          "https://images.ctfassets.net/foc8yxpzaiuk/WFEZbr6obtbPRG7msTVN6/3151320e157d9cfc3b282a1d6c19e743/11._Guide_to_Understanding_AI_Chatbots.jpg",
    ),
  ];

  @override
  void initState() {
    super.initState();
    UpdateChecker.checkForUpdate();
  }

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
                  "Services",
                  style: GoogleFonts.roboto(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisExtent: 150,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: serviceList.length,
                    itemBuilder: (context, index) {
                      final service = serviceList[index];
                      return InkWell(
                        onTap: () {
                          switch (service.id) {
                            case 1:
                              GoRouter.of(context)
                                  .push(RouteNames.googleOpinionRewardScreen);
                              break;
                            case 2:
                              context.push(RouteNames.chatGptScreen);

                              break;
                          }
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Card(
                              elevation: 5,
                              child: Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(
                                        height: 40,
                                      ),
                                      Text(
                                        service.name,
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
                            Positioned.fill(
                              top: -30,
                              left: 10,
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      Image.network(service.imageUrl).image,
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
