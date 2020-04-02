import 'package:equatable/equatable.dart';

abstract class PhoneSignInEvent extends Equatable {
  const PhoneSignInEvent();
}

class SignInButtonPressed extends PhoneSignInEvent {
  @override
  List<Object> get props => [null];

  @override
  String toString() => 'PhoneSignIn button pressed';
}

class PhoneChanged extends PhoneSignInEvent {
  final String phone;

  PhoneChanged(this.phone);

  @override
  List<Object> get props => null;

  @override
  String toString() => 'phone changed';
}

class PasswordChanged extends PhoneSignInEvent {
  final String password;

  PasswordChanged(this.password);

  @override
  List<Object> get props => null;

  @override
  String toString() => 'password changed';
}
