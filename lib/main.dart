import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habit_shift/landing_page.dart';
import 'package:habit_shift/notification/notification_helper.dart';
import 'package:habit_shift/services/auth.dart';
import 'package:provider/provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
NotificationAppLaunchDetails notifLaunch;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // var initializationSettingsAndroid =
  //     AndroidInitializationSettings('facebooklogo');
  // var initializationSettings =
  //     InitializationSettings(android: initializationSettingsAndroid);
  // await flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //     onSelectNotification: (String payload) async {
  //   if (payload != null) {
  //     debugPrint('notification payload: ' + payload);
  //   }
  // });
  notifLaunch =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  await NotificationClass().initNotifications(flutterLocalNotificationsPlugin);
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // call this app habiate
  // This widget is the root of your application.
  //firestore requirements involve Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    // Using Provider to provide an Auth object to the widget tree
    return Provider<AuthBase>(
      create: (context) => Auth(),
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.amber,
            brightness: Brightness.light,
            accentColor: Colors.amberAccent,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: LandingPage(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
