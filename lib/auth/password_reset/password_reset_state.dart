import 'package:equatable/equatable.dart';

abstract class PasswordResetState extends Equatable {
  const PasswordResetState();

  @override
  List<Object> get props => null;
}

class ResetRequired extends PasswordResetState {
  final bool isEmailValid;

  ResetRequired({this.isEmailValid});
}

class FieldChanged extends PasswordResetState {}

class GettingConfirmationCode extends PasswordResetState {}

class ResetLoading extends PasswordResetState {}

class ResetFailure extends PasswordResetState {
  final String error;

  const ResetFailure({this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'Reset failure { error: $error }';
}

class ConfirmReset extends PasswordResetState {
  final bool isPasswordValid;
  final bool isCodeValid;

  ConfirmReset({this.isPasswordValid, this.isCodeValid});
}

class ResetSuccess extends PasswordResetState {}
