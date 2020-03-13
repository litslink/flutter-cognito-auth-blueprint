import 'package:equatable/equatable.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => null;
}

class SignUpLoading extends SignUpState {}

class SignUpRequired extends SignUpState {}

class SignUpFailure extends SignUpState {
  final String error;

  const SignUpFailure({this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'SignUpFailure { error: $error }';
}

class SignUpSuccess extends SignUpState {}

class SignUpConfirmation extends SignUpState {}

class SignUpMovingToSignIn extends SignUpState {}
