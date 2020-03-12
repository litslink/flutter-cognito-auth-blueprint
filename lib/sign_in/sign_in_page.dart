import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../data/repository/authentication_repository.dart';
import 'sign_in_bloc.dart';
import 'sign_in_form.dart';

class SignInPage extends StatelessWidget {
  static final String route = '/signIn';

  @override
  Widget build(BuildContext context) {
    final authenticationRepository =
        Provider.of<AuthenticationRepository>(context);
    return Material(
        child: BlocProvider(
            create: (context) {
              return SignInBloc(authenticationRepository);
            },
            child: Container(
                margin: EdgeInsets.only(top: 20.0), child: SignInForm())));
  }
}
