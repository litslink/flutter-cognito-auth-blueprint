import 'package:flutter/material.dart';
import 'package:flutter_cognito_plugin/flutter_cognito_plugin.dart';
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
      {@required String email, @required String password}) async {
    return await Cognito.signIn(email, password);
  }

  Future<UserState> signInWithGoogle() async {
    final user = await googleSignIn.signIn();
    final auth = await user.authentication;
    return await Cognito.federatedSignIn("google", auth.idToken);
  }

  Future<void> signInWithFacebook() async {}

  Future<SignUpResult> signUp(
      {@required String email, @required String password}) async {
    final attrs = {'email': '$email'};
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
