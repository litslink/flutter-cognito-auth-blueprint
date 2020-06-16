import 'package:flutter/material.dart';
import 'package:flutter_cognito_plugin/flutter_cognito_plugin.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationRepository {
  final GoogleSignIn googleSignIn;

  AuthenticationRepository(this.googleSignIn);

  Future<UserState> initCognito() async {
    return await Cognito.initialize();
  }

  Future<UserState> getUserStatus() async {
    return await Cognito.getCurrentUserState();
  }

  Future<SignInResult> signIn(
      {@required String username, @required String password}) async {
    return await Cognito.signIn(username, password);
  }

  Future<UserState> signInWithGoogle() async {
    final user = await googleSignIn.signIn();
    final auth = await user.authentication;
    return await Cognito.federatedSignIn("accounts.google.com", auth.idToken);
  }

  Future<UserState> signInWithFacebook() async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);
    return await Cognito.federatedSignIn("facebook", result.accessToken.token);
  }

  Future<SignUpResult> signUp(
      {@required String username, @required String password}) async {
    return await Cognito.signUp(username, password);
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
