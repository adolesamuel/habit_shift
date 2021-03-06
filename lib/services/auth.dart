import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:habit_shift/home/models/user_object.dart';

abstract class AuthBase {
  Future<void> signOut();
  Stream<User> get onUserAuthStateChanged;
  Future<User> signInAnonymously();
  // Future<User> signInWithGoogle();
  // Future<User> signInWithFacebook();
  Future<User> signInWithEmailAndPassword({String email, String password});
  Future<User> createUserWithEmailAndPassword({String email, String password});
  UserObject userFromFirebaseOnSignUp(User user);
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  UserObject userFromFirebaseOnSignUp(User user) {
    if (user == null)
      return null;
    else
      return UserObject(
        uid: user.uid,
        email: user.isAnonymous ? 'Anonymous' : user.email,
        displayName: user.isAnonymous ? 'Anonymous' : 'Add UserName',
        //TODO: placeholder photourl
        photoUrl: user.isAnonymous ? null : null,
        numOfTasks: 0,
        isPremiumUser: false,
        dateCreated: DateTime.now(),
      );
  }

  //return a stream of Firebase User whenever user signs in or out
  @override
  Stream<User> get onUserAuthStateChanged {
    return _firebaseAuth.userChanges();
  }

  @override
  Future<User> signInWithEmailAndPassword(
      {String email, String password}) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return authResult.user;
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      {String email, String password}) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return authResult.user;
  }

  @override
  Future<User> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();

    return authResult.user;
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
