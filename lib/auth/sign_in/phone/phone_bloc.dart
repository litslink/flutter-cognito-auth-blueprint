import 'package:bloc/bloc.dart';
import 'package:flutter_cognito_plugin/models.dart';
import '../../../data/repository/authentication_repository.dart';
import '../../../validation/validation_bloc.dart';
import '../../../validation/validation_state.dart';
import '../../../validation/validator.dart';
import 'phone_event.dart';
import 'phone_state.dart';

class PhoneSignInBloc extends Bloc<PhoneSignInEvent, PhoneSignInState> {
  final AuthenticationRepository _authenticationRepository;

  PhoneSignInBloc(this._authenticationRepository);

  final _phone = ValidationBloc(NonEmptyValidator());
  final _password = ValidationBloc(PasswordValidator());
  final _code = ValidationBloc(ConfirmationCodeValidator());

  @override
  PhoneSignInState get initialState =>
      SignInRequired(isPhoneValid: true, isPasswordValid: true);

  @override
  Stream<PhoneSignInState> mapEventToState(
    PhoneSignInEvent event,
  ) async* {
    switch (event.runtimeType) {
      case SignInButtonPressed:
        yield SignInLoading();
        SignInResult user;
        try {
          if (_phone.state is FieldValid && _password.state is FieldValid) {
            user = await _authenticationRepository.signIn(
                username: (_phone.state as FieldValid).text,
                password: (_password.state as FieldValid).text);
          }
          if (user != null && user.signInState == SignInState.DONE) {
            yield SignInSuccess();
          } else {
            yield SignInRequired(
                isPhoneValid: _phone.state is FieldValid,
                isPasswordValid: _password.state is FieldValid);
          }
        } on Exception catch (error) {
          yield SignInFailure(error: error.toString());
          yield SignInRequired(isPhoneValid: true, isPasswordValid: true);
        }
        break;
      case PhoneChanged:
        yield FieldChanged();
        final phone = (event as PhoneChanged).phone;
        _phone.add(phone);
        yield SignInRequired(isPhoneValid: true, isPasswordValid: true);
        break;
      case PasswordChanged:
        yield FieldChanged();
        final password = (event as PasswordChanged).password;
        _password.add(password);
        yield SignInRequired(isPhoneValid: true, isPasswordValid: true);
        break;
    }
  }

  @override
  Future<void> close() {
    _phone.close();
    _password.close();
    _code.close();
    return super.close();
  }
}
