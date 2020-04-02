import 'package:equatable/equatable.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();
}

class SignInButtonPressed extends SignInEvent {
  @override
  List<Object> get props => null;

  @override
  String toString() => 'SignIn button pressed';
}

class SignUpWithEmailPressed extends SignInEvent {
  @override
  List<Object> get props => null;

  @override
  String toString() => 'going to SignUp with email page';
}

class SignUpWithPhonePressed extends SignInEvent {
  @override
  List<Object> get props => null;

  @override
  String toString() => 'going to SignUp with phone page';
}

class ResetButtonPressed extends SignInEvent {
  @override
  List<Object> get props => null;
}

class SignInWithGooglePressed extends SignInEvent {
  @override
  List<Object> get props => null;

  @override
  String toString() => 'signing in with google';
}

class SignInWithPhonePressed extends SignInEvent {
  @override
  List<Object> get props => null;

  @override
  String toString() => 'signing in with phone';
}

class SignInWithFacebookPressed extends SignInEvent {
  @override
  List<Object> get props => null;

  @override
  String toString() => 'signing in with facebook';
}

class EmailChanged extends SignInEvent {
  final String email;

  EmailChanged(this.email);

  @override
  List<Object> get props => null;

  @override
  String toString() => 'email changed';
}

class PasswordChanged extends SignInEvent {
  final String password;

  PasswordChanged(this.password);

  @override
  List<Object> get props => null;

  @override
  String toString() => 'password changed';
}
