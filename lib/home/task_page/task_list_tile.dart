import 'package:flutter/material.dart';
import 'package:habit_shift/home/models/task_object.dart';

class TaskListTile extends StatelessWidget {
  final Task task;
  final Function(bool value) onTap;
  final VoidCallback onEditTap;
  final VoidCallback onDeleteTap;

  const TaskListTile({
    Key key,
    this.task,
    this.onTap,
    this.onEditTap,
    this.onDeleteTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[600],
      child: Column(
        children: [
          SwitchListTile(
            title: Text(task.taskName),
            subtitle: Text(
                '${task.taskComment} : ${task.startTime.hour}:${task.startTime.minute}'),
            value: task.active,
            onChanged: (bool value) {
              onTap(value);
            },
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
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
