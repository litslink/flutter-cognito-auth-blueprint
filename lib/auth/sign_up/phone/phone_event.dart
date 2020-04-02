import 'package:equatable/equatable.dart';

abstract class PhoneSignUpEvent extends Equatable {
  const PhoneSignUpEvent();
}

class SignUpButtonPressed extends PhoneSignUpEvent {
  @override
  List<Object> get props => [null];

  @override
  String toString() => 'PhoneSignUn button pressed';
}

class SignInButtonPressed extends PhoneSignUpEvent {
  @override
  List<Object> get props => null;

  @override
  String toString() => 'going to SignIn page';
}

class ConfirmSignUpPressed extends PhoneSignUpEvent {
  @override
  List<Object> get props => null;

  @override
  String toString() => 'confirming phone sign up';
}

class PhoneChanged extends PhoneSignUpEvent {
  final String phone;

  PhoneChanged(this.phone);

  @override
  List<Object> get props => null;

  @override
  String toString() => 'phone changed';
}

class PasswordChanged extends PhoneSignUpEvent {
  final String password;

  PasswordChanged(this.password);

  @override
  List<Object> get props => null;

  @override
  String toString() => 'password changed';
}

class ConfirmationCodeChanged extends PhoneSignUpEvent {
  final String code;

  ConfirmationCodeChanged(this.code);

  @override
  List<Object> get props => null;

  @override
  String toString() => 'confirmation code changed';
}
