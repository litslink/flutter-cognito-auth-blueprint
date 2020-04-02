import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => null;
}

class SignInLoading extends LoginState {}

class SignInRequired extends LoginState {
  final bool isEmailValid;
  final bool isPasswordValid;

  SignInRequired({this.isEmailValid, this.isPasswordValid});
}

class FieldChanged extends LoginState {}

class SignInFailure extends LoginState {
  final String error;

  const SignInFailure({this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'SignInFailure { error: $error }';
}

class SignInSuccess extends LoginState {}

class SignInMovingToEmailSignUp extends LoginState {}

class SignInMovingToPhoneSignUp extends LoginState {}

class SignInMovingToPhonePage extends LoginState {}

class SignInWithGoogle extends LoginState {}

class SignInWithFacebook extends LoginState {}

class ResetPassword extends LoginState {}

class ConfirmationCode extends LoginState {}

class ResetLoading extends LoginState {}

class ResetFailure extends LoginState {
  final String error;

  const ResetFailure({this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ResetFailure { error: $error }';
}
