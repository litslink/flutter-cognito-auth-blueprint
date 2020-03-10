import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../authentication/authentication_bloc.dart';
import 'sign_in_bloc.dart';
import 'sign_in_form.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: BlocProvider(
            create: (context) {
              return SignInBloc(
                  authenticationBloc:
                      BlocProvider.of<AuthenticationBloc>(context));
            },
            child: Container(
                margin: EdgeInsets.only(top: 20.0), child: SignInForm())));
  }
}
