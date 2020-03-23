import 'package:equatable/equatable.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => null;
}

class SignUpLoading extends SignUpState {}

class ConfirmationLoading extends SignUpState {}

class SignUpRequired extends SignUpState {
  final bool isEmailValid;
  final bool isPasswordValid;

  SignUpRequired({this.isEmailValid, this.isPasswordValid});
}

class FieldChanged extends SignUpState {}

class SignUpFailure extends SignUpState {
  final String error;

  const SignUpFailure({this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'SignUpFailure { error: $error }';
}

class SignUpSuccess extends SignUpState {}

class SignUpConfirmation extends SignUpState {
  final bool isCodeValid;

  SignUpConfirmation({this.isCodeValid});
}

class SignUpMovingToSignIn extends SignUpState {}
