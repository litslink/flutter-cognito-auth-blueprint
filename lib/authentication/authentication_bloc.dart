import 'package:bloc/bloc.dart';

import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  @override
  AuthenticationState get initialState => AuthenticationUnauthenticated();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppLaunched) {
      yield AuthenticationUnauthenticated();
    }
    if (event is SignedIn) {
      yield AuthenticationLoading();
      yield AuthenticationAuthenticated();
    }

    if (event is SignedOut) {
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
