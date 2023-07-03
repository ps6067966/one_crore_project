import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:one_crore_project/constant/color.dart';

import '../../routing/route_const.dart';
import '../../widgets/prefetch_image.dart';
import '../../widgets/traingle_painter.dart';

class ThinkModel {
  final int id;
  final String name;
  final String description;
  String imageUrl;
  bool showCommingSoon = false;
  ThinkModel(
      {required this.id,
      required this.name,
      required this.description,
      required this.imageUrl,
      this.showCommingSoon = false});
}

class ThinkScreen extends ConsumerStatefulWidget {
  const ThinkScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ThinkScreenState();
}

class _ThinkScreenState extends ConsumerState<ThinkScreen> {
  final brainStorming = FirebaseStorage.instance.ref("brain_storming.png");
  final life = FirebaseStorage.instance.ref("life.png");
  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;
  List<ThinkModel> thinkList = [
    ThinkModel(
      id: 1,
      name: "Brain Storming",
      description: "Discover your hidden potential",
      imageUrl: "",
    ),
    ThinkModel(
      id: 2,
      name: "Know Yourself",
      description: "Thoughts, Feelings, and Actions",
      imageUrl: "",
      showCommingSoon: true,
    ),
  ];

  Future<void> _createRewardedAd() async {
    await RewardedAd.load(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-5015092669331169/2820712567'
            : 'ca-app-pub-3940256099942544/1712485313',
        request: const AdRequest(keywords: [
          "google",
          "opinion",
          "reward",
          "AI",
          "Artificial Intelligence"
        ]),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            log('$ad loaded.');
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            log('RewardedAd failed to load: $error');
            _rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
              _createRewardedAd();
            }
          },
        ));
  }

  Future<void> _showRewardedAd() async {
    if (_rewardedAd == null) {
      await _createRewardedAd();
    }
    if (_rewardedAd == null) {
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          log('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        log('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        log('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      log('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
    });
    _rewardedAd = null;
  }

  @override
  void initState() {
    super.initState();
    brainStorming.getDownloadURL().then((value) => {
          if (mounted)
            {
              setState(() {
                thinkList[0].imageUrl = value;
              })
            }
        });
    life.getDownloadURL().then((value) => {
          if (mounted)
            {
              setState(() {
                thinkList[1].imageUrl = value;
              })
            }
        });
    _createRewardedAd();
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
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 60,
                      mainAxisExtent: 150,
                    ),
                    itemCount: thinkList.length,
                    itemBuilder: (context, index) {
                      final think = thinkList[index];
                      return InkWell(
                        onTap: () {
                          _showRewardedAd();
                          switch (think.id) {
                            case 1:
                              context.push(RouteNames.chatScreen);
                              break;
                            case 2:
                              // context.push(RouteNames.knowYourselfScreen);
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
                                        height: 50,
                                      ),
                                      Text(
                                        think.name,
                                        style: GoogleFonts.roboto(
                                          fontSize: 25,
                                          color: primaryBlackColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                      Text(
                                        think.description,
                                        style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          color: primaryBlackColor,
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
                                      decoration: BoxDecoration(
                                          color: think.showCommingSoon
                                              ? Colors.white
                                              : primaryColor,
                                          borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(6.0),
                                              bottomLeft:
                                                  Radius.circular(6.0))),
                                      width: 120.0,
                                      height: 30.0,
                                      child: Center(
                                        child: Text(
                                          think.showCommingSoon
                                              ? 'Coming Soon'
                                              : "Live",
                                          style: TextStyle(
                                              color: think.showCommingSoon
                                                  ? primaryBlackColor
                                                  : Colors.white),
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
