import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:one_crore_project/routing/route_const.dart';
import 'package:one_crore_project/screens/think/share_wisdom/add_wisdom_screen.dart';
import 'package:one_crore_project/util/utils.dart';
import 'package:one_crore_project/widgets/custom_circular_indicator.dart';

import '../../../constant/color.dart';

class ShareWisdomScreen extends ConsumerStatefulWidget {
  const ShareWisdomScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ShareWisdomScreenState();
}

class _ShareWisdomScreenState extends ConsumerState<ShareWisdomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.isDarkMode ? null : Colors.grey[200],
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(RouteNames.addWisdomScreen);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
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
                  "Share Wisdom",
                  style: GoogleFonts.robotoFlex(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder(
                  stream: wisdomCollection
                      .orderBy("id", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CustomCircularIndicator();
                    }
                    final data = snapshot.data?.docs;
                    return ListView.builder(
                      itemCount: data?.length ?? 0,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final wisdom = data?[index].data();
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: context.isDarkMode
                                ? primaryBlackColor
                                : Colors.white,
                            surfaceTintColor: Colors.white,
                            shadowColor: primaryColor,
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(),
                                        image: DecorationImage(
                                          image: ExtendedNetworkImageProvider(
                                            wisdom?["photo_url"] ?? "",
                                            cache: true,
                                          ),
                                        )),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    "\"${wisdom?["wisdom"]}\"",
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    "${wisdom?["name"]}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
