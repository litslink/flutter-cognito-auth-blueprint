import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../authentication/authentication_bloc.dart';
import '../authentication/authentication_event.dart';
import 'sign_up_event.dart';
import 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthenticationBloc authenticationBloc;

  SignUpBloc({@required this.authenticationBloc});

  @override
  SignUpState get initialState => SignUpFailure();

  @override
  Stream<SignUpState> mapEventToState(
    SignUpEvent event,
  ) async* {
    if (event is SignUpButtonPressed) {
      yield SignUpLoading();
      authenticationBloc.add(SignedIn());
    }

    if (event is SignInButtonPressed) {
      authenticationBloc.add(MoveToSignIn());
    }
  }
}
