import 'package:bloc/bloc.dart';
import '../../data/repository/authentication_repository.dart';
import '../../util/validation/validation_bloc.dart';
import '../../util/validation/validation_state.dart';
import '../../util/validation/validator.dart';
import 'password_reset_event.dart';
import 'password_reset_state.dart';

class PasswordResetBloc extends Bloc<PasswordResetEvent, PasswordResetState> {
  final AuthenticationRepository _authenticationRepository;

  PasswordResetBloc(this._authenticationRepository);

  final _email = ValidationBloc(EmailValidator());
  final _password = ValidationBloc(PasswordValidator());
  final _code = ValidationBloc(ConfirmationCodeValidator());

  @override
  PasswordResetState get initialState => ResetRequired(isEmailValid: true);

  @override
  Stream<PasswordResetState> mapEventToState(
    PasswordResetEvent event,
  ) async* {
    if (event is GetConfirmationCodePressed) {
      yield GettingConfirmationCode();
      try {
        if (_email.state is FieldValid) {
          await _authenticationRepository.resetPassword(
              username: (_email.state as FieldValid).text);
          yield ConfirmReset(isPasswordValid: true, isCodeValid: true);
        } else {
          yield ResetRequired(isEmailValid: _email.state is FieldValid);
        }
      } on Exception catch (error) {
        yield ResetFailure(error: error.toString());
        yield ResetRequired(isEmailValid: true);
      }
    }

    if (event is ConfirmResetButtonPressed) {
      yield ResetLoading();
      try {
        if (_password.state is FieldValid && _code.state is FieldValid) {
          await _authenticationRepository.confirmPasswordReset(
              username: (_email.state as FieldValid).text,
              newPassword: (_password.state as FieldValid).text,
              confirmationCode: (_code.state as FieldValid).text);
          yield ResetSuccess();
        } else {
          yield ConfirmReset(
              isPasswordValid: _password.state is FieldValid,
              isCodeValid: _code.state is FieldValid);
        }
      } on Exception catch (error) {
        yield ResetFailure(error: error.toString());
        yield ConfirmReset(isPasswordValid: true, isCodeValid: true);
      }
    }

    if (event is EmailChanged) {
      yield FieldChanged();
      _email.add(event.email);
      yield ResetRequired(isEmailValid: true);
    }

    if (event is PasswordChanged) {
      yield FieldChanged();
      _password.add(event.password);
      yield ConfirmReset(isPasswordValid: true, isCodeValid: true);
    }

    if (event is ConfirmationCodeChanged) {
      yield FieldChanged();
      _code.add(event.code);
      yield ConfirmReset(isPasswordValid: true, isCodeValid: true);
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
