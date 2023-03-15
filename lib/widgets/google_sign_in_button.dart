import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:one_crore_project/model/post_model/user_post_model.dart';
import 'package:one_crore_project/repository/user_repository.dart';
import 'package:one_crore_project/widgets/prefetch_image.dart';

import '../routing/route_const.dart';

class GoogleSignButton extends ConsumerWidget {
  GoogleSignButton({super.key});

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;

  final googleIcon = const PrefetchImage(
    imageUrl: "https://img.icons8.com/fluency/48/null/google-logo.png",
    width: 30,
    height: 30,
  );

  void onTapGoogle(context) async {
    if (auth.currentUser != null) {
      GoRouter.of(context).push(RouteNames.mainScreen);
    } else {
      await googleSignIn.signIn();
      final GoogleSignInAccount? googleUser = googleSignIn.currentUser;
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential userCredential =
            await auth.signInWithCredential(credential);
        if (userCredential.user != null) {
          UserModel? user;
          try {
            user = await UsersRepository.createUser(
              userName: googleUser.email.split("@")[0],
              email: googleUser.email,
              fullName: googleUser.displayName ?? "",
              photoUrl: googleUser.photoUrl ?? "",
              mobileNumber: "",
            );
          } catch (e) {
            user = await UsersRepository.getUserByEmail(googleUser.email);
          } finally {
            if (user?.email != null && user!.email!.isNotEmpty) {
              GoRouter.of(context).push(RouteNames.mainScreen);
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: googleSignIn.onCurrentUserChanged,
        builder: (context, snapshot) {
          return InkWell(
            onTap: () {
              onTapGoogle(context);
            },
            child: SizedBox(
              width: size.width * 0.66,
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: snapshot.connectionState == ConnectionState.active
                      ? const Center(
                          child: SizedBox(
                              width: 30,
                              height: 30,
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              googleIcon,
                              const SizedBox(width: 10),
                              Text("Continue with Google",
                                  style: GoogleFonts.robotoFlex(
                                    fontSize: 17,
                                  )),
                            ]),
                ),
              ),
            ),
          );
        });
  }
}
