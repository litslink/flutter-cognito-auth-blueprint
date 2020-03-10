import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../authentication/authentication_bloc.dart';
import 'sign_up_bloc.dart';
import 'sign_up_form.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: BlocProvider(
            create: (context) {
              return SignUpBloc(
                  authenticationBloc:
                      BlocProvider.of<AuthenticationBloc>(context));
            },
            child: Container(
                margin: EdgeInsets.only(top: 20.0), child: SignUpForm())));
  }
}
