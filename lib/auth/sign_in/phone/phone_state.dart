import 'package:equatable/equatable.dart';

abstract class PhoneSignInState extends Equatable {
  const PhoneSignInState();

  @override
  List<Object> get props => null;
}

class SignInLoading extends PhoneSignInState {}

class SignInRequired extends PhoneSignInState {
  final bool isPhoneValid;
  final bool isPasswordValid;

  SignInRequired({this.isPhoneValid, this.isPasswordValid});
}

class FieldChanged extends PhoneSignInState {}

class SignInFailure extends PhoneSignInState {
  final String error;

  const SignInFailure({this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'PhoneSignInFailure { error: $error }';
}

class SignInSuccess extends PhoneSignInState {}
