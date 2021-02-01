import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_shift/common/platform_exception_alert_dialog.dart';
import 'package:habit_shift/common/sign_in_button.dart';
import 'package:habit_shift/home/models/user_object.dart';
import 'package:habit_shift/services/auth.dart';
import 'package:habit_shift/sign_in/sign_in_bloc.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  final SignInBloc bloc;

  SignInPage({Key key, @required this.bloc}) : super(key: key);

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return Provider<SignInBloc>(
      create: (context) => SignInBloc(auth: auth),
      child: Consumer<SignInBloc>(
        builder: (context, bloc, _) => SignInPage(
          bloc: bloc,
        ),
      ),
      dispose: (context, bloc) => bloc.dispose(),
    );
  }

  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Sign in Failed',
      exception: exception,
    ).show(context);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      print('signIn anon tried bloc:$bloc');
      UserObject user = await bloc?.signInAnonymously();
      print('User: ${user?.uid}');
    } on PlatformException catch (e) {
      _showSignInError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Habit Shift'),
        elevation: 2.0,
        centerTitle: true,
      ),
      body: StreamBuilder<bool>(
        stream: bloc.isLoadingStream,
        initialData: false,
        builder: (context, snapshot) {
          return _buildContent(context, snapshot.data);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isLoading) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              child: _buildHeader(isLoading),
              height: 50,
            ),
            SizedBox(
              height: 48.0,
            ),
            SizedBox(
              child: _emailSignInForm(),
              height: 8.0,
            ),
            SignInButton(
              text: 'Try our No account Mode',
              textColor: Colors.black,
              color: Colors.lime[300],
              onPressed: isLoading ? null : () => _signInAnonymously(context),
            ),
          ],
        ),
      ),
    );
  }

  _buildHeader(bool isLoading) {}

  _emailSignInForm() {}
}
