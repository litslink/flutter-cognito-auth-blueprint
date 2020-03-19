import 'package:equatable/equatable.dart';

abstract class ValidationEvent extends Equatable {
  const ValidationEvent();
}

class FieldChanged extends ValidationEvent {
  final String field;

  const FieldChanged({this.field});

  @override
  List<Object> get props => [field];

  @override
  String toString() => 'Field changed $field ';
}

class ValidationFailed extends ValidationEvent {
  final String email;
  final String password;

  const ValidationFailed({this.email, this.password});

  @override
  List<Object> get props => [email, password];

  @override
  String toString() => 'Validation failed $email, $password ';
}

class ValidationSuccess extends ValidationEvent {
  final String email;
  final String password;

  const ValidationSuccess({this.email, this.password});

  @override
  List<Object> get props => [email, password];

  @override
  String toString() => 'Validation success $email, $password ';
}
