import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habit_shift/home/models/task_object.dart';
import 'package:habit_shift/home/task_page/edit_task_page.dart';
import 'package:habit_shift/home/task_page/list_items_builder.dart';
import 'package:habit_shift/home/task_page/task_list_tile.dart';
import 'package:habit_shift/notification/notification_helper.dart';
import 'package:habit_shift/services/database.dart';
import 'package:provider/provider.dart';

class TasksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final database = Provider.of<Database>(context);
    // final np = Provider.of<FlutterLocalNotificationsPlugin>(context);
    return StreamBuilder<List<Task>>(
      stream: database.tasksStream(),
      builder: (context, snapshot) {
        // var taskList = snapshot.data;

        //for task in task list
        //if notification isn't scheduled, schedule it based on task data
        //else do nothing

        // for (Task task in taskList) {
        //   NotificationClass().showDailyAtTime(
        //       notificationsPlugin: np, task: task);
        // }
        return ListItemsBuilder<Task>(
          snapshot: snapshot,
          itemBuilder: (context, task) {
            return TaskListTile(
              task: task,
              onTap: () =>
                  EditTaskPage.show(context, database: database, task: task),
            );
          },
        );
      },
    );
  }

  void notificationScheduler(BuildContext context, Task task) {
    final notificationsPlugin =
        Provider.of<FlutterLocalNotificationsPlugin>(context);
    //get notifications plugin.
    //get list of scheduled tasks
    //check if task is scheduled, if not
    //if task is a daily task use showdailyattime
    //if task is a hourly task use othermethods.
  }
}
