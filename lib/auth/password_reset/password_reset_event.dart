import 'package:equatable/equatable.dart';

abstract class PasswordResetEvent extends Equatable {}

class GetConfirmationCodePressed extends PasswordResetEvent {
  @override
  List<Object> get props => null;

  @override
  String toString() => 'getting confirmation code password';
}

class ConfirmResetButtonPressed extends PasswordResetEvent {
  @override
  List<Object> get props => null;

  @override
  String toString() => 'confirm resetting password';
}

class EmailChanged extends PasswordResetEvent {
  final String email;

  EmailChanged(this.email);

  @override
  List<Object> get props => null;

  @override
  String toString() => 'email changed';
}

class PasswordChanged extends PasswordResetEvent {
  final String password;

  PasswordChanged(this.password);

  @override
  List<Object> get props => null;

  @override
  String toString() => 'password changed';
}

class ConfirmationCodeChanged extends PasswordResetEvent {
  final String code;

  ConfirmationCodeChanged(this.code);

  @override
  List<Object> get props => null;

  @override
  String toString() => 'confirmation code changed';
}
