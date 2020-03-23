import 'package:equatable/equatable.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();
}

class SignUpButtonPressed extends SignUpEvent {
  @override
  List<Object> get props => [null];

  @override
  String toString() => 'SignUn button pressed';
}

class SignInButtonPressed extends SignUpEvent {
  @override
  List<Object> get props => null;

  @override
  String toString() => 'going to SignIn page';
}

class ConfirmSignUpPressed extends SignUpEvent {
  @override
  List<Object> get props => null;

  @override
  String toString() => 'confirming sign up';
}

class EmailChanged extends SignUpEvent {
  final String email;

  EmailChanged(this.email);

  @override
  List<Object> get props => null;

  @override
  String toString() => 'email changed';
}

class PasswordChanged extends SignUpEvent {
  final String password;

  PasswordChanged(this.password);

  @override
  List<Object> get props => null;

  @override
  String toString() => 'password changed';
}

class ConfirmationCodeChanged extends SignUpEvent {
  final String code;

  ConfirmationCodeChanged(this.code);

  @override
  List<Object> get props => null;

  @override
  String toString() => 'confirmation code changed';
}
