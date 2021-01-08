import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habit_shift/home/models/task_object.dart';
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

  void dispose() {
    didRecieveLocalNotificationSubject.close();
    selectNotificationSubject.close();
  }

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

  Future<List<String>> checkPendingNotificationRequest(
      {@required FlutterLocalNotificationsPlugin notificationsPlugin}) async {
    final List<PendingNotificationRequest> pendingNotificationRequest =
        await notificationsPlugin.pendingNotificationRequests();
    return pendingNotificationRequest.map((e) => e.id.toString()).toList();
  }

  Future<void> showOnGoingNotification(
      {@required FlutterLocalNotificationsPlugin notificationsPlugin}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel Name',
      'your channel Description',
      importance: Importance.max,
      priority: Priority.high,
      ongoing: true,
      autoCancel: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await notificationsPlugin.show(0, 'All Notifications',
        'ongoing Notification body', platformChannelSpecifics);
  }

  Future<void> repeatNotificationMinute(
      {@required FlutterLocalNotificationsPlugin notificationsPlugin,
      @required Task task}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('repeating channel id',
            'repeating channel name', 'repeating description');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await notificationsPlugin.periodicallyShow(task.id.hashCode, task.taskName,
        task.taskComment, RepeatInterval.everyMinute, platformChannelSpecifics);
  }

  Future<void> repeatNotificationHour(
      {@required FlutterLocalNotificationsPlugin notificationsPlugin,
      @required Task task}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('repeating channel id',
            'repeating channel name', 'repeating description');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await notificationsPlugin.periodicallyShow(task.id.hashCode, task.taskName,
        task.taskComment, RepeatInterval.hourly, platformChannelSpecifics);
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
      {@required FlutterLocalNotificationsPlugin notificationsPlugin,
      @required Task task}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await notificationsPlugin.show(0, 'Show Notification once ${task.taskName}',
        'Yay it\'s working', platformChannelSpecifics,
        payload: 'item x');
  }

  Future<void> showDailyAtTime(
      {@required FlutterLocalNotificationsPlugin notificationsPlugin,
      @required Task task}) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'show weekly channel id',
      'show weekly channel name',
      'show weekly description',
      visibility: NotificationVisibility.public,
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
    final now = DateTime.now();
    final tzdateTime = tz.TZDateTime.from(
        DateTime(
          now.year + 1,
          now.month,
          now.day,
          task.startTime.hour,
          task.startTime.minute,
        ),
        location);

    await notificationsPlugin.zonedSchedule(
      task.id.hashCode,
      task.taskName,
      task.taskComment,
      tzdateTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelNotification(
      {@required FlutterLocalNotificationsPlugin notificationsPlugin,
      @required Task task}) async {
    await notificationsPlugin.cancel(task.id.hashCode);
  }

  Future<void> cancelAllNotifications(
      FlutterLocalNotificationsPlugin nP) async {
    await nP.cancelAll();
  }
}
