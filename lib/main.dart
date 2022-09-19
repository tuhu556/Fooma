import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodhub/config/routes.dart';
import 'package:foodhub/constants/color.dart';
import 'package:foodhub/session/session.dart';
import 'package:foodhub/theme.dart';
import 'package:responsive_framework/responsive_framework.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  //firebase push notification
  AwesomeNotifications().createNotificationFromJsonData(message.data);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AwesomeNotifications()
      .initialize('resource://drawable/res_notification_app_icon', [
    NotificationChannel(
      channelKey: 'basic_channel',
      channelName: 'Basic Notification',
      channelDescription: '',
      defaultColor: FoodHubColors.colorFC6011,
      importance: NotificationImportance.High,
      channelShowBadge: true,
      locked: false,
    ),
    NotificationChannel(
      channelKey: 'scheduled_channel',
      channelName: 'Scheduled Notification',
      channelDescription: '',
      defaultColor: FoodHubColors.colorFC6011,
      importance: NotificationImportance.High,
      locked: false,
    )
  ]);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100005),
        channelKey: 'basic_channel',
        title: message.data['title'],
        body: message.data['body'],
        notificationLayout: NotificationLayout.Default,
      ),
    );
  });
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await ApplicationSesson.shared.loadSession();

  String intialRoute() {
    final credential = ApplicationSesson.shared.credential;
    if (credential == null) {
      return Routes.signIn;
    }

    final deltaTime = (DateTime.now().millisecondsSinceEpoch -
            credential.authenticationTime) /
        1000;

    if (deltaTime < credential.accessTokenExpireIn - 7) {
      // refresh the token if it not valid
      // Networking().refreshToken();

      return Routes.mainTab;
    }

    return Routes.signIn;
  }

  String? token = await FirebaseMessaging.instance.getToken();
  print("tokenFireBase: " + token.toString());
  runApp(
    MaterialApp(
      builder: (context, widget) => ResponsiveWrapper.builder(
        ClampingScrollWrapper.builder(context, widget!),
        defaultScale: true,
        maxWidth: 1200,
        minWidth: 480,
        breakpoints: const [
          ResponsiveBreakpoint.resize(480, name: MOBILE),
          ResponsiveBreakpoint.autoScale(600, name: TABLET),
          ResponsiveBreakpoint.resize(800, name: DESKTOP),
          ResponsiveBreakpoint.autoScale(1700, name: 'XL'),
          ResponsiveBreakpoint.autoScale(2460, name: "4K"),
        ],
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: intialRoute(),
      theme: theme(),
      routes: routes,
    ),
  );
}
