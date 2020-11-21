import 'package:meta/meta.dart';

class APIPath {
  static String task({@required String uid, @required String taskId}) =>
      'users/$uid/tasks/$taskId';
  static String tasks({@required String uid}) => 'users/$uid/tasks';

  static String entry({String uid, String entryId}) =>
      'users/$uid/entries/$entry';

  static String entries({String uid}) => 'users/$uid/entries';
}
