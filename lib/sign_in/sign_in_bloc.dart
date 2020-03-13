import 'package:bloc/bloc.dart';
import 'package:flutter_cognito_plugin/models.dart';
import '../data/repository/authentication_repository.dart';
import 'sign_in_event.dart';
import 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, LoginState> {
  final AuthenticationRepository _authenticationRepository;

  SignInBloc(this._authenticationRepository);

  @override
  LoginState get initialState => SignInRequired();

  @override
  Stream<LoginState> mapEventToState(
    SignInEvent event,
  ) async* {
    if (event is SignInButtonPressed) {
      yield SignInLoading();
      SignInResult user;
      try {
        user = await _authenticationRepository.signIn(
            email: event.email, password: event.password);
      } on Exception catch (error) {
        yield SignInFailure(error: error.toString());
      }

      if (user != null && user.signInState.toString() == "SignInState.DONE") {
        yield SignInSuccess();
      } else {
        yield SignInFailure();
      }
    }

    if (event is SignUpButtonPressed) {
      yield SignInMovingToSignUp();
    }
  }
}
