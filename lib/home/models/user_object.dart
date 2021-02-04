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
    this.premiumUser,
  });

  final String uid;
  final String email;
  final String photoUrl;
  final String displayName;
  final int numOfTasks;
  final bool premiumUser;
  //email,photourl,displayname, number of tasks, premium or free user.

  factory UserObject.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) return null;

    String email = data['email'];
    String photoUrl = data['photoUrl'];
    String displayName = data['displayName'];
    int numOfTasks = data['numOfTasks'];
    bool premiumUser = data['premiumUser'];

    return UserObject(
        uid: documentId,
        email: email,
        photoUrl: photoUrl,
        displayName: displayName,
        numOfTasks: numOfTasks,
        premiumUser: premiumUser);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'photoUrl': photoUrl,
      'displayName': displayName,
      'numOfTasks': numOfTasks,
      'premiumUser': premiumUser,
    };
  }

  UserObject userObjectFromFirebaseUser(User user) {
    if (user == null) {
      return null;
    } else {
      return UserObject(
        uid: user.uid,
        email: user.email,
      );
    }
  }
}
