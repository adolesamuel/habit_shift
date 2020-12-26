import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habit_shift/notification/timezone_helper.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationClass {
  final int id;
  final String title;
  final String body;
  final String payload;

  NotificationClass({this.id, this.title, this.body, this.payload});

  final BehaviorSubject<NotificationClass> didRecieveLocalNotificationSubject =
      BehaviorSubject<NotificationClass>();

  final BehaviorSubject<String> selectNotificationSubject =
      BehaviorSubject<String>();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin notifsPlugin) async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('notifyicon');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await notifsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String payload) async {
        if (payload != null) {
          print('Notification Payload:$payload');
        }
        selectNotificationSubject.add(payload);
      },
    );
    print('Notification Initialised successfully');
  }

  Future<void> scheduleNotification(
      {FlutterLocalNotificationsPlugin notifsPlugin,
      String id,
      String title,
      String body,
      DateTime scheduledTime}) async {
    var androidSpecifics = AndroidNotificationDetails(
      id,
      'Scheduled Notification',
      'A Scheduled Notification from Habiate',
      icon: 'notifyicon',
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidSpecifics);
    await notifsPlugin.schedule(
        0,
        title,
        'Scheduled Notification body',
        scheduledTime,
        platformChannelSpecifics); // This line schedules the notification.
  }

  Future<void> showNotification(
      {FlutterLocalNotificationsPlugin notifsPlugin,
      String id,
      String title,
      String body,
      DateTime scheduledTime}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await notifsPlugin.show(0, 'Show Notification once', 'Yay it\'s working',
        platformChannelSpecifics,
        payload: 'item x');
  }

  Future<void> showDailyAtTime(
      {FlutterLocalNotificationsPlugin notifsPlugin,
      String id,
      String title,
      String body,
      DateTime scheduledTime}) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'show weekly channel id',
      'show weekly channel name',
      'show weekly description',
    );
    final iOsPlatfromChannelSpecifics = IOSNotificationDetails();
    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOsPlatfromChannelSpecifics,
    );

    //gets device  location using TimeZone Helperfile
    final timeZone = TimeZone();

    String timeZoneName = await timeZone.getTimeZoneName();

    final location = await timeZone.getLocation(timeZoneName);

    // returns tzdatetime from datetime and location.
    final tzdateTime = tz.TZDateTime.from(scheduledTime, location);

    await notifsPlugin.zonedSchedule(
      id.hashCode,
      title,
      body,
      tzdateTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
