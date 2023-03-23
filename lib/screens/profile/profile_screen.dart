import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:one_crore_project/constant/color.dart';
import 'package:one_crore_project/routing/route_const.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;
  // FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  // bool _isCreatingLink = false;
  // String _linkMessage = '';

  // Future<void> _createDynamicLink(bool short) async {
  //   setState(() {
  //     _isCreatingLink = true;
  //   });

  //   final DynamicLinkParameters parameters = DynamicLinkParameters(
  //     uriPrefix: 'https://flashcoders.page.link',
  //     longDynamicLink: Uri.parse(
  //       'https://flashcoders.page.link?efr=0&ibi=com.flashcoders.one_cr_project&apn=com.flashcoders.one_cr_project&imv=0&amv=0&link=https%3A%2F%2Fexample%2Fhelloworld&ofl=https://ofl-example.com',
  //     ),
  //     link: Uri.parse("https://flashcoders.page.link"),
  //     androidParameters: const AndroidParameters(
  //       packageName: 'com.flashcoders.one_cr_project',
  //       minimumVersion: 0,
  //     ),
  //   );

  //   Uri url;
  //   if (short) {
  //     final ShortDynamicLink shortLink =
  //         await dynamicLinks.buildShortLink(parameters);
  //     url = shortLink.shortUrl;
  //   } else {
  //     url = await dynamicLinks.buildLink(parameters);
  //   }

  //   setState(() {
  //     _linkMessage = "Download kr lo mera app es link se : ${url.toString()}";
  //     _isCreatingLink = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 140,
                      width: double.infinity,
                      color: Colors.amber,
                    ),
                    Positioned(
                        top: 14,
                        right: 14,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Color(0xff473c55),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () async {
                              await auth.signOut();
                              await GoogleSignIn().signOut();
                              if (auth.currentUser == null) {
                                if (mounted) {
                                  context.go(RouteNames.authScreen);
                                }
                              }
                            },
                            icon: const Icon(
                              Icons.logout_rounded,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ))
                  ],
                ),
                Positioned(
                  bottom: -60,
                  left: 50,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: ExtendedNetworkImageProvider(
                          currentUser?.photoURL ?? "",
                          cache: true,
                        ),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(color: primaryBlackColor, width: 3),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xff473c55),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.edit,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 14,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    top: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 145,
                            child: Text(
                              currentUser?.displayName ?? "",
                              style: GoogleFonts.robotoFlex(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          const Icon(
                            Icons.verified_rounded,
                            color: Colors.green,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        "@${currentUser?.email?.split("@")[0] ?? ""}",
                        style: GoogleFonts.robotoFlex(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      // ListTile(
                      //   onTap: () async {
                      //     await _createDynamicLink(true);
                      //     Share.share(_linkMessage);
                      //   },
                      //   trailing: const Icon(
                      //     Icons.share_rounded,
                      //     color: Colors.white,
                      //   ),
                      //   title: const Text("Refer Your Friends"),
                      // )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
