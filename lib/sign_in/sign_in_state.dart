import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => null;
}

class SignInLoading extends LoginState {}

class SignInRequired extends LoginState {}

class SignInFailure extends LoginState {
  final String error;

  const SignInFailure({this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'SignInFailure { error: $error }';
}

class SignInSuccess extends LoginState {}

class SignInMovingToSignUp extends LoginState {}
