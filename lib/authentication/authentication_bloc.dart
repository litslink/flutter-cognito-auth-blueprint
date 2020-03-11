import 'package:bloc/bloc.dart';
import '../data/repository/authentication_repository.dart';

import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;

  AuthenticationBloc(this._authenticationRepository);

  @override
  AuthenticationState get initialState => AuthenticationUnauthenticated();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppLaunched) {
      yield AuthenticationUnauthenticated();
      await _authenticationRepository.initCognito();
    }
    if (event is SignIn) {
      yield AuthenticationLoading();
      try {
        await _authenticationRepository.signIn(
            email: event.email, password: event.password);
        yield AuthenticationAuthenticated();
      } on Exception catch (error) {
        yield AuthenticationFailure(error: error.toString());
      }
    }

    if (event is SignUp) {
      yield AuthenticationLoading();
      try {
        await _authenticationRepository.signUp(
            email: event.email, password: event.password);
        yield AuthenticationAuthenticated();
      } on Exception catch (error) {
        yield AuthenticationFailure(error: error.toString());
      }
    }

    if (event is SignOut) {
      yield AuthenticationLoading();
      yield AuthenticationUnauthenticated();
    }

    if (event is MoveToSignUp) {
      yield AuthenticationSignUpNeeded();
    }

    if (event is MoveToSignIn) {
      yield AuthenticationUnauthenticated();
    }
  }
}
