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
    switch (event.runtimeType) {
      case SignInButtonPressed:
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
        break;
      case SignInWithGooglePressed:
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
        break;
      case SignInWithFacebookPressed:
        yield SignInWithFacebook();
        try {
          final userState =
              await _authenticationRepository.signInWithFacebook();
          if (userState != null && userState == UserState.SIGNED_IN) {
            yield SignInSuccess();
          } else {
            yield SignInRequired(isEmailValid: true, isPasswordValid: true);
          }
        } on Exception catch (error) {
          yield SignInFailure(error: error.toString());
          yield SignInRequired(isEmailValid: true, isPasswordValid: true);
        }
        break;
      case SignInWithPhonePressed:
        yield SignInMovingToPhonePage();
        break;
      case SignUpWithEmailPressed:
        yield SignInMovingToEmailSignUp();
        break;
      case SignUpWithPhonePressed:
        yield SignInMovingToPhoneSignUp();
        break;
      case ResetButtonPressed:
        yield ResetPassword();
        break;
      case EmailChanged:
        yield FieldChanged();
        final email = (event as EmailChanged).email;
        _email.add(email);
        yield SignInRequired(isEmailValid: true, isPasswordValid: true);
        break;
      case PasswordChanged:
        yield FieldChanged();
        final password = (event as PasswordChanged).password;
        _password.add(password);
        yield SignInRequired(isEmailValid: true, isPasswordValid: true);
        break;
    }
  }

  @override
  Future<void> close() {
    _email.close();
    _password.close();
    return super.close();
  }
}
