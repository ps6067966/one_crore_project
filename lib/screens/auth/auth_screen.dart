import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:one_crore_project/constant/assets_const.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  static List<Image> imageList = [
    Image.asset(Assets.onboarding1, fit: BoxFit.cover),
    Image.asset(Assets.onboarding2, fit: BoxFit.cover),
    Image.asset(Assets.onboarding3, fit: BoxFit.cover),
  ];

  @override
  void didChangeDependencies() async {
    await precacheImage(imageList[0].image, context);
    if (mounted) {
      await precacheImage(imageList[1].image, context);
    }
    if (mounted) {
      await precacheImage(imageList[2].image, context);
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              FlutterCarousel(
                options: CarouselOptions(
                  height: size.height * 0.7,
                  showIndicator: true,
                  indicatorMargin: size.height * 0.66,
                  viewportFraction: 1,
                  autoPlay: true,
                  slideIndicator: const CircularSlideIndicator(),
                ),
                items: imageList.map((i) {
                  return Stack(
                    children: [
                      Container(
                        width: size.width,
                        height: size.height * 0.7,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: i,
                      ),
                      Positioned(
                        top: 60,
                        width: size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            right: 20,
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              imageList.indexOf(i) == 0
                                  ? "Live the Life You Deserve"
                                  : imageList.indexOf(i) == 1
                                      ? "Unlimited Free Rewards"
                                      : "Welcome to the Future",
                              style: GoogleFonts.robotoFlex(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
              Positioned.fill(
                bottom: -(size.height * 0.25),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: BottomSheet(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    onClosing: () {},
                    enableDrag: false,
                    builder: (context) {
                      return Card(
                        elevation: 1,
                        margin: EdgeInsets.zero,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: SizedBox(
                          width: size.width,
                          height: size.height * 0.27,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                child: Text(
                                  "Unlock the secret of life!",
                                  style: GoogleFonts.robotoFlex(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: size.width * 0.8,
                                child: Text(
                                  "Get access to all the features of the app by signing in with your Google account",
                                  style: GoogleFonts.robotoFlex(
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                onTap: () {},
                                child: SizedBox(
                                  width: size.width * 0.66,
                                  child: Card(
                                    elevation: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.network(
                                              "https://img.icons8.com/fluency/48/null/google-logo.png",
                                              width: 30,
                                              height: 30,
                                            ),
                                            const SizedBox(width: 10),
                                            Text("Continue with Google",
                                                style: GoogleFonts.robotoFlex(
                                                  fontSize: 17,
                                                )),
                                          ]),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }
}
