import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../authentication/authentication_bloc.dart';
import '../authentication/authentication_event.dart';
import 'sign_in_event.dart';
import 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthenticationBloc authenticationBloc;

  SignInBloc({@required this.authenticationBloc});

  @override
  SignInState get initialState => SignInFailure();

  @override
  Stream<SignInState> mapEventToState(
    SignInEvent event,
  ) async* {
    if (event is SignInButtonPressed) {
      yield SignInLoading();
      authenticationBloc
          .add(SignIn(email: event.username, password: event.password));
    }

    if (event is SignUpButtonPressed) {
      yield SignInMovingToSignUp();
      authenticationBloc.add(MoveToSignUp());
    }
  }
}
