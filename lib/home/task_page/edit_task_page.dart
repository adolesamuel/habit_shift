import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_shift/common/date_time_picker.dart';
import 'package:habit_shift/common/platform_alert_dialog.dart';
import 'package:habit_shift/common/platform_exception_alert_dialog.dart';
import 'package:habit_shift/home/models/task_object.dart';
import 'package:habit_shift/services/database.dart';

class EditTaskPage extends StatefulWidget {
  final Database database;
  final Task task;

  EditTaskPage({Key key, this.database, this.task}) : super(key: key);

  static Future<void> show(
    BuildContext context, {
    Database database,
    Task task,
  }) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditTaskPage(database: database, task: task),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final _editTaskFormKey = GlobalKey<FormState>();

  String _taskName;
  String _taskComment;
  TimeOfDay _startTime;
  int _hours;
  int _minutes;
  TaskPriority _priority;
  Frequency _frequency;

  bool _validateAndSaveForm() {
    final form = _editTaskFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final tasks = await widget.database.tasksStream().first;
        final allNames = tasks.map((task) => task.taskName).toList();
        if (widget.task != null) {
          allNames.remove(widget.task.taskName);
        }
        if (allNames.contains(widget.task?.taskName)) {
          PlatformAlertDialog(
                  title: 'Task Name already used',
                  content: 'Please choose a differenc Task Name',
                  defaultActionText: 'OK')
              .show(context);
        } else {
          final id = widget.task?.id ?? documentIdFromCurrentDate();
          // Details of task when created
          // values are either created here or in the task object model.
          final task = Task(
            id: id,
            taskName: _taskName,
            taskComment: _taskComment,
            dateCreated: DateTime.now(),
            startTime: _startTime,
            taskDuration: Duration(
              hours: _hours,
              minutes: _minutes,
            ),
            priority: _priority ?? TaskPriority.none,
            repeat: true,
            frequency: _frequency ?? Frequency.none,
            active: true,
          );
          await widget.database.setTask(task);
          Navigator.of(context).pop();
        }
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation Failed',
          exception: e,
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'New Job' : widget.task.taskName),
        actions: <Widget>[
          FlatButton(
              onPressed: _submit,
              child: Text(
                'Save',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ))
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _editTaskFormKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildFormChildren(),
        ),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        initialValue: _taskName,
        onSaved: (value) => _taskName = value,
        decoration: InputDecoration(labelText: 'Task name'),
        onEditingComplete: () => _validateAndSaveForm(),
      ),
      TextFormField(
        initialValue: _taskComment,
        onSaved: (value) => _taskComment = value,
        decoration: InputDecoration(labelText: 'Task Description'),
      ),
      SizedBox(
        height: 8,
      ),
      //Time selector...
      DateTimePicker(
        labelText: 'Pick Time',
        selectedTime: _startTime ??
            widget.task?.startTime ??
            TimeOfDay(hour: 6, minute: 30),
        onSelectedTime: (value) {
          _startTime = value;
          setState(() {});
        },
      ),
      // DateTime _taskDuration
      Row(
        children: _buildDurationRow(),
      ),
      // Priority _priority
      // Frequency _frequency
      Row(
        children: _buildPriorityandFrequencyRow(),
      ),
    ];
  }

  List<Widget> _buildDurationRow() {
    return [
      Expanded(
        flex: 4,
        child: TextFormField(
          onSaved: (value) => _hours = int.tryParse(value) ?? 0,
          initialValue: _hours != null ? '$_hours' : null,
          decoration: InputDecoration(labelText: 'Duration Hrs'),
          keyboardType: TextInputType.numberWithOptions(
            signed: false,
            decimal: false,
          ),
        ),
      ),
      Expanded(
        flex: 4,
        child: TextFormField(
          onSaved: (value) => _minutes = int.tryParse(value) ?? 0,
          initialValue: _minutes != null ? '$_minutes' : null,
          decoration: InputDecoration(labelText: 'Duration Mins'),
          keyboardType: TextInputType.numberWithOptions(
            signed: false,
            decimal: false,
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildPriorityandFrequencyRow() {
    return [];
  }
}
