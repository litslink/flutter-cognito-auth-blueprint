import 'package:bloc/bloc.dart';
import 'package:flutter_cognito_plugin/models.dart';
import '../data/repository/authentication_repository.dart';
import 'sign_up_event.dart';
import 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthenticationRepository _authenticationRepository;

  SignUpBloc(this._authenticationRepository);

  @override
  SignUpState get initialState => SignUpRequired();

  @override
  Stream<SignUpState> mapEventToState(
    SignUpEvent event,
  ) async* {
    if (event is SignUpButtonPressed) {
      yield SignUpLoading();
      SignUpResult user;
      try {
        user = await _authenticationRepository.signUp(
            email: event.email, password: event.password);
      } on Exception catch (error) {
        yield SignUpFailure(error: error.toString());
      }

      if (user != null) {
        yield SignUpSuccess();
      } else {
        yield SignUpFailure();
      }
    }

    if (event is SignInButtonPressed) {
      yield SignUpMovingToSignIn();
    }
  }
}
