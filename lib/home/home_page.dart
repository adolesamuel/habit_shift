import 'package:flutter/material.dart';
import 'package:habit_shift/home/task_page/edit_task_page.dart';
import 'package:habit_shift/home/task_page/tasks_page.dart';
import 'package:habit_shift/main.dart';
import 'package:habit_shift/notification/notification_helper.dart';
import 'package:habit_shift/services/auth.dart';
import 'package:habit_shift/services/database.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    final database = Provider.of<Database>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: <Widget>[
          FlatButton(
            onPressed: auth.signOut,
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: TasksPage(),
      floatingActionButton: FloatingActionButton(
        //Todo: Provide database to method of edittaskpage.show
        onPressed: () => NotificationClass().scheduleNotification(
            notifsPlugin: flutterLocalNotificationsPlugin,
            id: DateTime.now().toString(),
            body: 'Scheduled Notification from FAB',
            scheduledTime: DateTime.now().add(Duration(minutes: 1))),
        // EditTaskPage.show(context, database: database),
        child: Icon(Icons.add),
      ),
    );
  }
}
