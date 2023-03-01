import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:one_crore_project/routing/route_const.dart';
import 'package:one_crore_project/screens/auth/auth_screen.dart';
import 'package:one_crore_project/screens/main/main_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: FirebaseAuth.instance.currentUser == null
      ? RouteNames.authScreen
      : RouteNames.mainScreen,
  routes: [
    GoRoute(
      path: RouteNames.authScreen,
      builder: (context, state) {
        return const AuthScreen();
      },
    ),
    GoRoute(
      path: RouteNames.mainScreen,
      builder: (context, state) {
        return const MainScreen();
      },
    ),
  ],
);
