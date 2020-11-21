import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:enum_to_string/enum_to_string.dart';

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
    // this.startTime,
    // this.taskDuration,
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
  // final TimeOfDay startTime;
  // final Duration taskDuration;
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
    // final DateTime startTime =
    //     DateTime.fromMillisecondsSinceEpoch(data['startTime']);
    // final DateTime taskDuration =
    // DateTime.fromMillisecondsSinceEpoch(data['taskDuration']);
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
      // startTime: TimeOfDay.fromDateTime(startTime),
      // taskDuration: Duration(
      //   hours: taskDuration.hour,
      //   minutes: taskDuration.minute,
      //   seconds: taskDuration.second,
      // ),
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
      // 'startTime': DateTime(0, 0, 0, startTime.hour, startTime.minute)
      //     .millisecondsSinceEpoch,
      // 'taskDuration': DateTime(
      //         0,
      //         0,
      //         0,
      //         taskDuration.inHours,
      //         taskDuration.inMinutes - (taskDuration.inHours * 60),
      //         taskDuration.inSeconds - (taskDuration.inMinutes * 60))
      //     .millisecondsSinceEpoch,
      'priority': EnumToString.convertToString(priority),
      'repeat': repeat,
      'frequency': EnumToString.convertToString(frequency),
      'active': active,
    };
  }
}
