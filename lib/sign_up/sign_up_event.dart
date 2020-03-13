import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();
}

class SignUpButtonPressed extends SignUpEvent {
  final String email;
  final String password;

  const SignUpButtonPressed({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [email, password];

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
  final String username;
  final String code;

  ConfirmSignUpPressed({@required this.code, @required this.username});

  @override
  List<Object> get props => null;

  @override
  String toString() => 'confirming sign up';
}
