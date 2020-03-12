import 'package:flutter/material.dart';
import 'package:flutter_cognito_plugin/flutter_cognito_plugin.dart';

class AuthenticationRepository {
  Future<UserState> initCognito() async {
    var res = await Cognito.initialize();
    return res;
  }

  Future<SignInResult> signIn(
      {@required String email, @required String password}) async {
    var res = await Cognito.signIn(email, password);
    return res;
  }

  Future<SignUpResult> signUp(
      {@required String email, @required String password}) async {
    var attrs = {'email': '$email'};
    var res = await Cognito.signUp(email, password, attrs);
    return res;
  }

  Future<void> signOut() async {
    await Cognito.signOut();
  }
}
