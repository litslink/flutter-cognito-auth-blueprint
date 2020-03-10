import 'package:equatable/equatable.dart';

abstract class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object> get props => null;
}

class SignInLoading extends SignInState {}

class SignInFailure extends SignInState {}

class SignInSuccess extends SignInState {}

class SignInMovingToSignUp extends SignInState {}
