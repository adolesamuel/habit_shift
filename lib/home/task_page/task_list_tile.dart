import 'package:flutter/material.dart';
import 'package:habit_shift/home/models/task_object.dart';

class TaskListTile extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const TaskListTile({Key key, this.task, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.taskName),
      onTap: onTap,
      trailing: Icon(Icons.chevron_right),
    );
  }
}
