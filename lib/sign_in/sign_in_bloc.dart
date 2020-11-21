import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:habit_shift/services/auth.dart';

class SignInBloc {
  final AuthBase auth;

  SignInBloc({@required this.auth});

  final StreamController<bool> _isLoadingController = StreamController<bool>();
  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  void dispose() {
    _isLoadingController.close();
  }

  void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  Future<UserObject> _signIn(Future<UserObject> Function() signInMethod) async {
    try {
      _setIsLoading(true);
      return await signInMethod();
    } catch (e) {
      _setIsLoading(false);
      rethrow;
    }
  }

  Future<UserObject> signInAnonymously() async =>
      await _signIn(auth.signInAnonymously);
}
