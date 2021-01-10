import 'package:flutter/material.dart';
import 'package:habit_shift/home/models/task_object.dart';
import 'package:habit_shift/services/database.dart';
import 'package:provider/provider.dart';

class TaskListTile extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const TaskListTile({Key key, this.task, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context);
    return SwitchListTile(
      title: Text(task.taskName),
      subtitle: Text(
          '${task.taskComment} : ${task.startTime.hour}:${task.startTime.minute}'),
      value: task.active,
      onChanged: (bool value) {
        database.setActive(task, value);
      },
    );
  }
}
