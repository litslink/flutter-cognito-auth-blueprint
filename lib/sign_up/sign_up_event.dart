import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../sign_in/sign_in_event.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();
}

class SignUpButtonPressed extends SignUpEvent {
  final String username;
  final String password;

  const SignUpButtonPressed({
    @required this.username,
    @required this.password,
  });

  @override
  List<Object> get props => [username, password];

  @override
  String toString() => 'SignUn button pressed';
}

class SignInButtonPressed extends SignUpEvent {
  @override
  List<Object> get props => null;

  @override
  String toString() => 'going to SignIn page';
}
