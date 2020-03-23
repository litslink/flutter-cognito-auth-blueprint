import 'package:flutter_bloc/flutter_bloc.dart';
import 'validation_state.dart';
import 'validator.dart';

class ValidationBloc extends Bloc<String, ValidationState> {
  final Validator validator;

  ValidationBloc(this.validator);

  @override
  ValidationState get initialState => FieldEmpty();

  @override
  Stream<ValidationState> mapEventToState(String event) async* {
    if (validator.validate(event)) {
      yield FieldValid(event);
    } else {
      yield FieldInvalid();
    }
  }
}
