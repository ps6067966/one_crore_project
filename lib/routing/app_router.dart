import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:one_crore_project/routing/route_const.dart';
import 'package:one_crore_project/screens/auth/auth_screen.dart';
import 'package:one_crore_project/screens/home/google_opinion_reward/google_opinion_reward.dart';
import 'package:one_crore_project/screens/home/google_opinion_reward/opinion_reward_transaction.dart';
import 'package:one_crore_project/screens/main/main_screen.dart';
import 'package:one_crore_project/screens/terms_privacy/privacy_screen.dart';
import 'package:one_crore_project/screens/terms_privacy/terms_screen.dart';
import 'package:one_crore_project/screens/think/know_yourself/know_yourself_screen.dart';

import '../analytics/analytics.dart';
import '../screens/chat/chat_gpt_screen.dart';
import '../screens/chat/chat_screem.dart';
import '../screens/home/google_opinion_reward/add_upi_account.dart';
import '../screens/reward/github_education_pack/github_education_pack_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: FirebaseAuth.instance.currentUser == null
      ? RouteNames.authScreen
      : RouteNames.mainScreen,
  observers: [
    FirebaseAnalyticsObserver(analytics: analytics),
  ],
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
      path: RouteNames.githubEducationPackScreen,
      builder: (context, state) {
        return const GithubEducationPackScreen();
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
          GoRoute(
            path: RouteNames.transactionsUrl,
            builder: (context, state) {
              return const OpinionRewardTransactions();
            },
          ),
        ]),
    GoRoute(
      path: RouteNames.chatScreen,
      builder: (context, state) {
        return const ChatRoomScreen();
      },
    ),
    GoRoute(
      path: RouteNames.chatGptScreen,
      builder: (context, state) {
        return const ChatGptScreen();
      },
    ),
    GoRoute(
      path: RouteNames.knowYourselfScreen,
      builder: (context, state) {
        return const KnowYourself();
      },
    ),
  ],
);
