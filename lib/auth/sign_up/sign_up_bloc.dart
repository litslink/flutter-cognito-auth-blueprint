import 'package:bloc/bloc.dart';
import 'package:flutter_cognito_plugin/models.dart';
import '../../data/repository/authentication_repository.dart';
import '../../validation/validation_bloc.dart';
import '../../validation/validation_state.dart';
import '../../validation/validator.dart';
import 'sign_up_event.dart';
import 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthenticationRepository _authenticationRepository;

  SignUpBloc(this._authenticationRepository);

  final _email = ValidationBloc(EmailValidator());
  final _password = ValidationBloc(PasswordValidator());
  final _code = ValidationBloc(ConfirmationCodeValidator());

  @override
  SignUpState get initialState =>
      SignUpRequired(isEmailValid: true, isPasswordValid: true);

  @override
  Stream<SignUpState> mapEventToState(
    SignUpEvent event,
  ) async* {
    if (event is SignUpButtonPressed) {
      yield SignUpLoading();
      SignUpResult res;
      try {
        if (_email.state is FieldValid && _password.state is FieldValid) {
          res = await _authenticationRepository.signUp(
              email: (_email.state as FieldValid).text,
              password: (_password.state as FieldValid).text);
        }
        if (res != null && res.confirmationState) {
          yield SignUpSuccess();
        } else if (res != null && !res.confirmationState) {
          yield SignUpConfirmation(isCodeValid: true);
        } else {
          yield SignUpRequired(
              isEmailValid: _email.state is FieldValid,
              isPasswordValid: _password.state is FieldValid);
        }
      } on Exception catch (error) {
        yield SignUpFailure(error: error.toString());
        yield SignUpRequired(isEmailValid: true, isPasswordValid: true);
      }
    }

    if (event is ConfirmSignUpPressed) {
      yield ConfirmationLoading();
      SignUpResult res;
      try {
        if (_code.state is FieldValid) {
          res = await _authenticationRepository.confirmSignUp(
              username: (_email.state as FieldValid).text,
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
        yield SignUpRequired(isEmailValid: true, isPasswordValid: true);
      }
    }

    if (event is SignInButtonPressed) {
      yield SignUpMovingToSignIn();
    }

    if (event is EmailChanged) {
      yield FieldChanged();
      _email.add(event.email);
      yield SignUpRequired(isEmailValid: true, isPasswordValid: true);
    }

    if (event is PasswordChanged) {
      yield FieldChanged();
      _password.add(event.password);
      yield SignUpRequired(isEmailValid: true, isPasswordValid: true);
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
    _email.close();
    _password.close();
    _code.close();
  }
}
