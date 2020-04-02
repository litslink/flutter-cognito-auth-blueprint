import 'package:bloc/bloc.dart';
import 'package:flutter_cognito_plugin/models.dart';
import '../../../data/repository/authentication_repository.dart';
import '../../../validation/validation_bloc.dart';
import '../../../validation/validation_state.dart';
import '../../../validation/validator.dart';
import 'phone_event.dart';
import 'phone_state.dart';

class PhoneSignUpBloc extends Bloc<PhoneSignUpEvent, PhoneSignUpState> {
  final AuthenticationRepository _authenticationRepository;

  PhoneSignUpBloc(this._authenticationRepository);

  final _phone = ValidationBloc(NonEmptyValidator());
  final _password = ValidationBloc(PasswordValidator());
  final _code = ValidationBloc(ConfirmationCodeValidator());

  @override
  PhoneSignUpState get initialState =>
      SignUpRequired(isPhoneValid: true, isPasswordValid: true);

  @override
  Stream<PhoneSignUpState> mapEventToState(
    PhoneSignUpEvent event,
  ) async* {
    if (event is SignUpButtonPressed) {
      yield SignUpLoading();
      SignUpResult res;
      try {
        if (_phone.state is FieldValid && _password.state is FieldValid) {
          res = await _authenticationRepository.signUp(
              username: (_phone.state as FieldValid).text,
              password: (_password.state as FieldValid).text);
        }
        if (res != null && res.confirmationState) {
          yield SignUpSuccess();
        } else if (res != null && !res.confirmationState) {
          yield SignUpConfirmation(isCodeValid: true);
        } else {
          yield SignUpRequired(
              isPhoneValid: _phone.state is FieldValid,
              isPasswordValid: _password.state is FieldValid);
        }
      } on Exception catch (error) {
        yield SignUpFailure(error: error.toString());
        yield SignUpRequired(isPhoneValid: true, isPasswordValid: true);
      }
    }
    if (event is ConfirmSignUpPressed) {
      yield ConfirmationLoading();
      SignUpResult res;
      try {
        if (_code.state is FieldValid) {
          res = await _authenticationRepository.confirmSignUp(
              username: (_phone.state as FieldValid).text,
              code: (_code.state as FieldValid).text);
        }
        if (res != null && res.confirmationState) {
          yield SignUpSuccess();
        } else if (res != null && !res.confirmationState) {
          yield SignUpConfirmation(isCodeValid: true);
        } else {
          yield SignUpConfirmation(isCodeValid: _code.state is FieldValid);
        }
      } on Exception catch (error) {
        yield SignUpFailure(error: error.toString());
        yield SignUpRequired(isPhoneValid: true, isPasswordValid: true);
      }
    }
    if (event is SignInButtonPressed) {
      yield SignUpMovingToSignIn();
    }
    if (event is PhoneChanged) {
      yield FieldChanged();
      _phone.add(event.phone);
      yield SignUpRequired(isPhoneValid: true, isPasswordValid: true);
    }
    if (event is PasswordChanged) {
      yield FieldChanged();
      _password.add(event.password);
      yield SignUpRequired(isPhoneValid: true, isPasswordValid: true);
    }
    if (event is ConfirmationCodeChanged) {
      yield FieldChanged();
      _code.add(event.code);
      yield SignUpConfirmation(isCodeValid: true);
    }
  }

  @override
  Future<Function> close() {
    super.close();
    _phone.close();
    _password.close();
    _code.close();
  }
}
