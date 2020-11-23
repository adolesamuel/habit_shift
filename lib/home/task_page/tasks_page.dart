import 'package:flutter/material.dart';
import 'package:habit_shift/home/models/task_object.dart';
import 'package:habit_shift/home/task_page/edit_task_page.dart';
import 'package:habit_shift/home/task_page/list_items_builder.dart';
import 'package:habit_shift/home/task_page/task_list_tile.dart';
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
    return StreamBuilder<List<Task>>(
      stream: database.tasksStream(),
      builder: (context, snapshot) {
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
}
