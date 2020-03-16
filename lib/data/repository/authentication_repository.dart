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

  Future<ForgotPasswordResult> resetPassword(
      {@required String username}) async {
    return await Cognito.forgotPassword(username);
  }

  Future<ForgotPasswordResult> confirmPasswordReset(
      {@required String username,
      @required String newPassword,
      @required String confirmationCode}) async {
    return await Cognito.confirmForgotPassword(
        username, newPassword, confirmationCode);
  }

  Future<void> signOut() async {
    await Cognito.signOut();
  }
}
