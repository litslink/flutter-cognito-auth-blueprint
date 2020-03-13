import 'package:flutter/material.dart';
import 'package:flutter_cognito_plugin/flutter_cognito_plugin.dart';

class AuthenticationRepository {
  Future<UserState> initCognito() async {
    return await Cognito.initialize();
  }

  Future<UserState> getUserStatus() async {
    return await Cognito.getCurrentUserState();
  }

  Future<SignInResult> signIn(
      {@required String email, @required String password}) async {
    return await Cognito.signIn(email, password);
  }

  Future<SignUpResult> signUp(
      {@required String email, @required String password}) async {
    var attrs = {'email': '$email'};
    return await Cognito.signUp(email, password, attrs);
  }

  Future<SignUpResult> confirmSignUp(
      {@required String username, @required String code}) async {
    return await Cognito.confirmSignUp(username, code);
  }

  Future<void> signOut() async {
    await Cognito.signOut();
  }
}
