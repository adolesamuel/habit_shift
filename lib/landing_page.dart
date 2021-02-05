import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_shift/home/home_page.dart';
import 'package:habit_shift/home/models/user_object.dart';
import 'package:habit_shift/services/auth.dart';
import 'package:habit_shift/services/database.dart';
import 'package:habit_shift/sign_in/sign_in_page.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ///uses a stream of auth, firebaseUser, personal userobject and database object
    /// to build pages.
    /// Streambuilder consumes firebaseUser [User]
    /// checks [User.uid] and goes to [SignInPage] if null and else [HomePage]
    /// HomePage is loaded with data from Userobject and Database that is created automatically on signup

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
            //exposing Firebaseuser to widgets that need it
            return Provider<User>.value(
              value: user,
              //streaming Userobject database data
              child: StreamBuilder<UserObject>(
                  stream: FirestoreDatabase(uid: user.uid)
                      .userObjectStream(uid: user.uid),
                  builder: (context, snapshot) {
                    UserObject userObjectStream = snapshot.data;

                    //using multiprovider to expose database and userobject entries to homepage
                    return MultiProvider(
                      providers: [
                        Provider<Database>(
                            create: (_) => FirestoreDatabase(uid: user.uid)),
                        Provider<UserObject>.value(value: userObjectStream),
                      ],
                      child: HomePage(),
                    );
                  }),
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
