import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => null;
}

class AppLaunched extends AuthenticationEvent {}

class SignedIn extends AuthenticationEvent {}

class SignedOut extends AuthenticationEvent {}

class MoveToSignUp extends AuthenticationEvent {}

class MoveToSignIn extends AuthenticationEvent {}
