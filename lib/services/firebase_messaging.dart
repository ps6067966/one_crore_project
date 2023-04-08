import 'package:firebase_messaging/firebase_messaging.dart';

import 'push_notification.dart';

class FirebaseMessagingService {
  static handleBackgroudFirebaseMessaging() {
    // fcm code starts here
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    firebaseMessaging.getToken().then((value) => storeToken(value));

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        // final routeFromMessage = message.data['route'];
      }
    });

    /// forground work
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      if (message != null) {
        PushNotificationService.display(message);
      }
    });

    // When the app is in background but open and user taps
    // on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // final routeFromMessage = message.data['route'];

      // Navigator.of(context).pushNamed(routeFromMessage);
    });
  }

  static Future<void> storeToken(var devicetoken) async {
    
  }
}
