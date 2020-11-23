import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

enum TaskPriority { none, first, second, third, fourth, fifth }
enum Frequency { none, daily, onceAWeek, onceAMonth }

//Enums are being saved to strings on firebase
// and converted back to enums on reciept

class Task {
  Task({
    @required this.id,
    @required this.taskName,
    this.taskComment,
    this.runCount,
    this.dateCreated,
    this.startTime,
    this.taskDuration,
    this.priority,
    this.repeat,
    this.frequency,
    this.active,
  });

  final String id;
  final String taskName;
  final String taskComment;
  final int runCount;
  final DateTime dateCreated;
  final TimeOfDay startTime;
  final Duration taskDuration;
  final TaskPriority priority;
  final bool repeat;
  final Frequency frequency;
  final bool active;

  factory Task.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String taskName = data['taskName'];
    final String taskComment = data['taskComment'];
    final int runCount = data['runCount'];
    final DateTime dateCreated = data['dateCreated'].toDate();
    final TimeOfDay startTime =
        TimeOfDay(hour: data['startTimeHr'], minute: data['startTimeMn']);
    final Duration taskDuration = Duration(
        hours: data['taskDurationHr'] ?? 0,
        minutes: data['taskDurationMn'] ?? 0);
    final TaskPriority priority =
        EnumToString.fromString(TaskPriority.values, data['priority']);
    final bool repeat = data['repeat'];
    final Frequency frequency =
        EnumToString.fromString(Frequency.values, data['frequency']);
    final bool active = data['active'];

    return Task(
      id: documentId,
      taskName: taskName,
      taskComment: taskComment,
      runCount: runCount,
      dateCreated: dateCreated,
      startTime: startTime,
      taskDuration: taskDuration,
      priority: priority,
      repeat: repeat,
      frequency: frequency,
      active: active,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskName': taskName,
      'taskComment': taskComment,
      'runCount': runCount,
      'dateCreated': dateCreated,
      'startTimeHr': startTime.hour,
      'startTimeMn': startTime.minute,
      'taskDurationHr': taskDuration.inHours,
      'taskDurationMn': taskDuration.inMinutes - (taskDuration.inHours * 60),
      'priority': EnumToString.convertToString(priority),
      'repeat': repeat,
      'frequency': EnumToString.convertToString(frequency),
      'active': active,
    };
  }
}
