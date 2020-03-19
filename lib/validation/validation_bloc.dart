import 'package:bloc/bloc.dart';
import 'validation_event.dart';
import 'validation_state.dart';

class ValidationBloc extends Bloc<ValidationEvent, ValidationState> {
  final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  @override
  ValidationState get initialState => FieldsIncorrect();

  @override
  Stream<ValidationState> mapEventToState(ValidationEvent event) async* {
    if (event is FieldChanged) {
      yield FieldsNotEmpty();
    }

    if (event is ValidationFailed) {
      yield FieldsIncorrect();
    }

    if (event is ValidationSuccess) {
      yield FieldsValidated();
    }
  }

  bool isEmailValid(String email) {
    return _emailRegExp.hasMatch(email);
  }

  bool isPasswordValid(String password) {
    return _passwordRegExp.hasMatch(password);
  }
}
