import 'package:bloc/bloc.dart';
import 'package:flutter_cognito_plugin/models.dart';
import '../../data/repository/authentication_repository.dart';
import '../../util/validation/validation_bloc.dart';
import '../../util/validation/validation_state.dart';
import '../../util/validation/validator.dart';
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
              email: (_email.state as FieldValid).text,
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
      final userState = await _authenticationRepository.signInWithGoogle();
    }

    if (event is SignInWithFacebookPressed) {
      yield SignInWithFacebook();
      await _authenticationRepository.signInWithFacebook();
    }

    if (event is SignUpButtonPressed) {
      yield SignInMovingToSignUp();
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
  Future<Function> close() {
    super.close();
    _email.close();
    _password.close();
  }
}
