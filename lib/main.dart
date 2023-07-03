import 'dart:developer';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'constant/color.dart';
import 'constant/global.dart';
import 'firebase_options.dart';
import 'local_storage/prefs.dart';
import 'routing/app_router.dart';
import 'services/push_notification.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    log("$e");
  }

  analytics.app.setAutomaticDataCollectionEnabled(true);
  analytics.setAnalyticsCollectionEnabled(true);
  analytics.logAppOpen();
  analytics.setConsent(
      adStorageConsentGranted: true, analyticsStorageConsentGranted: true);

  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
  await Prefs.init();
  PushNotificationService.initialize();

  runApp(ProviderScope(
      child: DevicePreview(
    enabled: false,
    builder: (context) => const MyApp(),
  )));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      builder: (context, child) {
        mediaQuery = MediaQuery.of(context);
        return child!;
      },
      routerConfig: router,
      title: 'I-Labs',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: const ColorScheme.dark(
          primary: primaryColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        useMaterial3: true,
        typography: Typography.material2021(),
        listTileTheme: const ListTileThemeData(
          textColor: Colors.white,
          style: ListTileStyle.list,
        ),
      ),
      theme: ThemeData.light(useMaterial3: true).copyWith(
        colorScheme: const ColorScheme.light(
          primary: primaryColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        useMaterial3: true,
        typography: Typography.material2021(),
        listTileTheme: const ListTileThemeData(
          textColor: primaryBlackColor,
          style: ListTileStyle.list,
        ),
      ),
    );
  }
}

FirebaseAnalytics analytics = FirebaseAnalytics.instance;
