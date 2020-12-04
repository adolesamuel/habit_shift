import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

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
}
