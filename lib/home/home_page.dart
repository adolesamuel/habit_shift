import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habit_shift/home/models/task_object.dart';
import 'package:habit_shift/home/task_page/edit_task_page.dart';
import 'package:habit_shift/home/task_page/tasks_page.dart';
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
        title: Text('Habiate'),
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
        onPressed: () => EditTaskPage.show(context, database: database),

        //test notification stack
        // NotificationClass().showNotification(
        //     notificationsPlugin: np,
        //     task: Task(
        //       id: '24567',
        //       taskName: 'Test Task Name',
        //       taskComment:
        //           'Task was scheduled from Home Page Floating Action Button',
        //       startTime: TimeOfDay.fromDateTime(DateTime.now()),
        //     )),

        child: Icon(Icons.add),
      ),
    );
  }
}
