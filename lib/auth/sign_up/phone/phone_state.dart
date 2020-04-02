import 'package:equatable/equatable.dart';

abstract class PhoneSignUpState extends Equatable {
  const PhoneSignUpState();

  @override
  List<Object> get props => null;
}

class SignUpLoading extends PhoneSignUpState {}

class ConfirmationLoading extends PhoneSignUpState {}

class SignUpRequired extends PhoneSignUpState {
  final bool isPhoneValid;
  final bool isPasswordValid;

  SignUpRequired({this.isPhoneValid, this.isPasswordValid});
}

class FieldChanged extends PhoneSignUpState {}

class SignUpFailure extends PhoneSignUpState {
  final String error;

  const SignUpFailure({this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'PhoneSignUpFailure { error: $error }';
}

class SignUpSuccess extends PhoneSignUpState {}

class SignUpConfirmation extends PhoneSignUpState {
  final bool isCodeValid;

  SignUpConfirmation({this.isCodeValid});
}

class SignUpMovingToSignIn extends PhoneSignUpState {}
