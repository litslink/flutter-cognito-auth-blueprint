import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => null;
}

class AppLaunched extends AuthenticationEvent {}

class SignIn extends AuthenticationEvent {
  final String email;
  final String password;

  const SignIn({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [email, password];

  @override
  String toString() => 'SignIn pressed';
}

class SignUp extends AuthenticationEvent {
  final String email;
  final String password;

  const SignUp({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [email, password];

  @override
  String toString() => 'SignUp pressed';
}

class SignOut extends AuthenticationEvent {}

class MoveToSignUp extends AuthenticationEvent {}

class MoveToSignIn extends AuthenticationEvent {}
