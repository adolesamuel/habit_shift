import 'package:flutter/material.dart';
import 'package:habit_shift/home/models/task_object.dart';
import 'package:habit_shift/services/database.dart';
import 'package:provider/provider.dart';

class TaskListTile extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onEditTap;
  final VoidCallback onDeleteTap;
  final VoidCallback onSwitchTap;

  const TaskListTile(
      {Key key,
      this.task,
      this.onTap,
      this.onEditTap,
      this.onDeleteTap,
      this.onSwitchTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context);
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            title: Text(task.taskName),
            subtitle: Text(
                '${task.taskComment} : ${task.startTime.hour}:${task.startTime.minute}'),
            value: task.active,
            onChanged: (bool value) {
              database.setActive(task, value);
            },
          ),
          Row(
            children: [
              IconButton(icon: Icon(Icons.edit), onPressed: onEditTap),
              IconButton(icon: Icon(Icons.delete), onPressed: onDeleteTap),
            ],
          )
        ],
      ),
    );
  }
}
