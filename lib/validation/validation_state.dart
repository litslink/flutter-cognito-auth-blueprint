import 'package:equatable/equatable.dart';

abstract class ValidationState extends Equatable {
  const ValidationState();

  @override
  List<Object> get props => null;
}

class FieldsNotEmpty extends ValidationState{}

class FieldsIncorrect extends ValidationState{}

class FieldsValidated extends ValidationState{}

