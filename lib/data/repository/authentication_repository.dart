import 'package:flutter/material.dart';
import 'package:flutter_cognito_plugin/flutter_cognito_plugin.dart';

class AuthenticationRepository {
  Future<void> initCognito() async {
    await Cognito.initialize();
  }

  Future<void> signIn(
      {@required String email, @required String password}) async {
    await Cognito.signIn(email, password);
  }

  Future<void> signUp(
      {@required String email, @required String password}) async {
    var attrs = {'email': '$email'};
    await Cognito.signUp(email, password, attrs);
  }

  Future<void> signOut() async {
    await Cognito.signOut();
  }
}
