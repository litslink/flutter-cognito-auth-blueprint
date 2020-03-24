abstract class ValidationState {}

class FieldEmpty extends ValidationState {}

class FieldInvalid extends ValidationState {}

class FieldValid extends ValidationState {
  final String text;

  FieldValid(this.text);
}

