import 'package:bloc/bloc.dart';
import 'package:flutter_cognito_plugin/models.dart';
import '../../data/repository/authentication_repository.dart';
import '../../validation/validation_bloc.dart';
import '../../validation/validation_state.dart';
import '../../validation/validator.dart';
import 'sign_in_event.dart';
import 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, LoginState> {
  final AuthenticationRepository _authenticationRepository;

  SignInBloc(this._authenticationRepository);

  final _email = ValidationBloc(EmailValidator());
  final _password = ValidationBloc(PasswordValidator());

  @override
  LoginState get initialState =>
      SignInRequired(isEmailValid: true, isPasswordValid: true);

  @override
  Stream<LoginState> mapEventToState(
    SignInEvent event,
  ) async* {
    if (event is SignInButtonPressed) {
      yield SignInLoading();
      SignInResult user;
      try {
        if (_email.state is FieldValid && _password.state is FieldValid) {
          user = await _authenticationRepository.signIn(
              username: (_email.state as FieldValid).text,
              password: (_password.state as FieldValid).text);
        }
        if (user != null && user.signInState == SignInState.DONE) {
          yield SignInSuccess();
        } else {
          yield SignInRequired(
              isEmailValid: _email.state is FieldValid,
              isPasswordValid: _password.state is FieldValid);
        }
      } on Exception catch (error) {
        yield SignInFailure(error: error.toString());
        yield SignInRequired(isEmailValid: true, isPasswordValid: true);
      }
    }
    if (event is SignInWithGooglePressed) {
      yield SignInWithGoogle();
      try {
        final userState = await _authenticationRepository.signInWithGoogle();
        if (userState != null && userState == UserState.SIGNED_IN) {
          yield SignInSuccess();
        } else {
          yield SignInRequired(isEmailValid: true, isPasswordValid: true);
        }
      } on Exception catch (error) {
        yield SignInFailure(error: error.toString());
        yield SignInRequired(isEmailValid: true, isPasswordValid: true);
      }
    }
    if (event is SignInWithFacebookPressed) {
      yield SignInWithFacebook();
      try {
        final userState = await _authenticationRepository.signInWithFacebook();
        if (userState != null && userState == UserState.SIGNED_IN) {
          yield SignInSuccess();
        } else {
          yield SignInRequired(isEmailValid: true, isPasswordValid: true);
        }
      } on Exception catch (error) {
        yield SignInFailure(error: error.toString());
        yield SignInRequired(isEmailValid: true, isPasswordValid: true);
      }
    }
    if (event is SignInWithPhonePressed) {
      yield SignInMovingToPhonePage();
    }
    if (event is SignUpWithEmailPressed) {
      yield SignInMovingToEmailSignUp();
    }
    if (event is SignUpWithPhonePressed) {
      yield SignInMovingToPhoneSignUp();
    }
    if (event is ResetButtonPressed) {
      yield ResetPassword();
    }
    if (event is EmailChanged) {
      yield FieldChanged();
      _email.add(event.email);
      yield SignInRequired(isEmailValid: true, isPasswordValid: true);
    }
    if (event is PasswordChanged) {
      yield FieldChanged();
      _password.add(event.password);
      yield SignInRequired(isEmailValid: true, isPasswordValid: true);
    }
  }

  @override
  Future<void> close() {
    _email.close();
    _password.close();
    return super.close();
  }
}
