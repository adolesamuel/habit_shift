//Class of app user items
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class UserObject {
  UserObject({
    @required this.uid,
    this.email,
    this.photoUrl,
    this.displayName,
    this.numOfTasks,
    this.isPremiumUser,
    this.dateCreated,
  });

  final String uid;
  final String email;
  final String photoUrl;
  final String displayName;
  final int numOfTasks;
  final bool isPremiumUser;
  final DateTime dateCreated;
  //email,photourl,displayname, number of tasks, premium or free user.

  factory UserObject.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) return null;

    String email = data['email'];
    String photoUrl = data['photoUrl'];
    String displayName = data['displayName'];
    int numOfTasks = data['numOfTasks'];
    bool isPremiumUser = data['isPremiumUser'];
    DateTime dateCreated = data['dateCreated'].toDate();

    return UserObject(
      uid: documentId,
      email: email,
      photoUrl: photoUrl,
      displayName: displayName,
      numOfTasks: numOfTasks,
      isPremiumUser: isPremiumUser,
      dateCreated: dateCreated,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'photoUrl': photoUrl,
      'displayName': displayName,
      'numOfTasks': numOfTasks,
      'isPremiumUser': isPremiumUser,
      'dateCreated': dateCreated,
    };
  }
}
