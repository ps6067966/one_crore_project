import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:one_crore_project/routing/route_const.dart';
import 'package:one_crore_project/screens/auth/auth_screen.dart';
import 'package:one_crore_project/screens/home/google_opinion_reward/google_opinion_reward.dart';
import 'package:one_crore_project/screens/main/main_screen.dart';
import 'package:one_crore_project/screens/terms_privacy/privacy_screen.dart';
import 'package:one_crore_project/screens/terms_privacy/terms_screen.dart';

import '../screens/home/google_opinion_reward/add_upi_account.dart';

final GoRouter router = GoRouter(
  initialLocation: FirebaseAuth.instance.currentUser == null
      ? RouteNames.authScreen
      : RouteNames.mainScreen,
  routes: [
    GoRoute(
      path: RouteNames.authScreen,
      builder: (context, state) {
        return AuthScreen();
      },
    ),
    GoRoute(
      path: RouteNames.privacyPolicy,
      builder: (context, state) {
        return const PrivacyScreen();
      },
    ),
    GoRoute(
      path: RouteNames.termsAndConditions,
      builder: (context, state) {
        return const TermsAndConditionScreen();
      },
    ),
    GoRoute(
      path: RouteNames.mainScreen,
      builder: (context, state) {
        return const MainScreen();
      },
    ),
    GoRoute(
      path: RouteNames.profileScreen,
      builder: (context, state) {
        return const MainScreen(
          index: 4,
        );
      },
    ),
    GoRoute(
        path: RouteNames.googleOpinionRewardScreen,
        builder: (context, state) {
          return const GoogleOpinionRewardScreen();
        },
        routes: [
          GoRoute(
            path: RouteNames.addUPIAccountUrl,
            builder: (context, state) {
              return const AddUPIAccountScreen();
            },
          ),
        ]),
  ],
);
