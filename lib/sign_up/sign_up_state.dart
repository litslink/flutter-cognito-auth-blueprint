import 'package:equatable/equatable.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => null;
}

class SignUpLoading extends SignUpState {}

class SignUpFailure extends SignUpState {}

class SignUpSuccess extends SignUpState {}
