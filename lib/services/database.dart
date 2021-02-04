import 'package:habit_shift/home/models/user_object.dart';
import 'package:habit_shift/services/api_path.dart';
import 'package:habit_shift/services/firestore_service.dart';
import 'package:meta/meta.dart';
import 'package:habit_shift/home/models/task_object.dart';

abstract class Database {
  Future<void> setTask(Task task);
  Future<void> setUserData(UserObject userObject);
  Future<void> deleteTask(Task task);
  Future<void> setActive(Task task, bool value);
  Future<void> updateUserField(
      {@required String field, @required dynamic value});
  Stream<List<Task>> tasksStream();
  Stream<Task> taskStream({@required String taskId});
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);

  final String uid;

  final _service = FirestoreService.instance;

  @override
  Future<void> setTask(Task task) async => await _service.setData(
      path: APIPath.task(uid: uid, taskId: task.id), data: task.toMap());

  @override
  Future<void> setUserData(UserObject userObject) async => await _service
      .setData(path: APIPath.userData(uid: uid), data: userObject.toMap());

  @override
  Future<void> setActive(Task task, bool value) async =>
      await _service.setActive(
        value: value,
        path: APIPath.task(uid: uid, taskId: task.id),
      );

  @override
  Future<void> updateUserField(
          {@required String field, @required dynamic value}) async =>
      await _service.updateUserField(
          path: APIPath.userData(uid: uid), field: field, value: value);

  @override
  Future<void> deleteTask(Task task) async {
    await _service.deleteData(path: APIPath.task(uid: uid, taskId: task.id));
  }

  @override
  Stream<Task> taskStream({@required String taskId}) => _service.documentStream(
        path: APIPath.task(uid: uid, taskId: taskId),
        builder: (data, documentId) => Task.fromMap(data, documentId),
      );

  @override
  Stream<List<Task>> tasksStream() => _service.collectionStream(
        path: APIPath.tasks(uid: uid),
        builder: (data, documentId) => Task.fromMap(data, documentId),
      );

  Stream<UserObject> userObjectStream({@required String uid}) =>
      _service.documentStream(
        path: APIPath.userData(uid: uid),
        builder: (data, uid) => UserObject.fromMap(data, uid),
      );
}
