import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();
}

class SignInButtonPressed extends SignInEvent {
  final String email;
  final String password;

  const SignInButtonPressed({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [email, password];

  @override
  String toString() => 'SignIn button pressed';
}

class SignUpButtonPressed extends SignInEvent {
  @override
  List<Object> get props => null;

  @override
  String toString() => 'going to SignUp page';
}
