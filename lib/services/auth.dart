import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:habit_shift/home/models/user_object.dart';

abstract class AuthBase {
  Future<void> signOut();
  Stream<UserObject> get onUserAuthStateChanged;
  Future<UserObject> signInAnonymously();
  // Future<UserObject> signInWithGoogle();
  // Future<UserObject> signInWithFacebook();
  Future<UserObject> signInWithEmailAndPassword(
      {String email, String password});
  Future<UserObject> createUserWithEmailAndPassword(
      {String email, String password});
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  //return userobject with uid.
  UserObject _userFromFirebase(User user) {
    if (user == null)
      return null;
    else
      return UserObject(
        uid: user.uid,
        email: user.email,
      );
  }

  //return a stream of Userobjects whenever user signs in or out
  @override
  Stream<UserObject> get onUserAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  @override
  Future<UserObject> signInWithEmailAndPassword(
      {String email, String password}) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<UserObject> createUserWithEmailAndPassword(
      {String email, String password}) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<UserObject> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();

    return _userFromFirebase(authResult.user);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
