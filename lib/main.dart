import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:master_car_project/controller/all_app_controller.dart';
import 'package:master_car_project/controller/notifiers/load_notification_notifier.dart';
import 'package:master_car_project/ui/home_page.dart';
import 'package:provider/provider.dart';
import 'controller/push_notification_controller.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  final firebaseMessaging = FCM();
  await Firebase.initializeApp();
  firebaseMessaging.setNotification();

  // await FirebaseMessaging.instance.getToken();
}

Future<void> main() async {
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StateNotifierProvider<LoggedController, LoggedState>(
            create: (context) => LoggedController()),
        StateNotifierProvider<LoadNotificationController, LoadState>(
          create: (context) => LoadNotificationController(),
        )
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        title: 'Flutter Demo',
        theme: ThemeData(fontFamily: 'GE'),
        supportedLocales: const [
          Locale('ar', 'AE'), // Arabic,
        ],
        home: const Home(),
      ),
    );
  }
}
