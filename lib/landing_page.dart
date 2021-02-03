import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_shift/home/home_page.dart';
import 'package:habit_shift/services/auth.dart';
import 'package:habit_shift/services/database.dart';
import 'package:habit_shift/sign_in/sign_in_page.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //listening to onAuthStatechanged
    final auth = Provider.of<AuthBase>(context);
    return StreamBuilder<User>(
      stream: auth.onUserAuthStateChanged,
      builder: (context, snapshot) {
        print(snapshot.connectionState);
        if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.none) {
          User user = snapshot.data;
          if (user == null) {
            return SignInPage.create(context);
          } else {
            return Provider<User>.value(
              value: user,
              child: Provider<Database>(
                create: (_) => FirestoreDatabase(uid: user.uid),
                child: HomePage(),
              ),
            );
          }
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
