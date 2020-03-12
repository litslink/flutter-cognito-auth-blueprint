import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../data/repository/authentication_repository.dart';
import 'sign_up_bloc.dart';
import 'sign_up_form.dart';

class SignUpPage extends StatelessWidget {
  static final String route = '/signUp';

  @override
  Widget build(BuildContext context) {
    final authenticationRepository =
        Provider.of<AuthenticationRepository>(context);
    return Material(
        child: BlocProvider(
            create: (context) {
              return SignUpBloc(authenticationRepository);
            },
            child: Container(
                margin: EdgeInsets.only(top: 20.0), child: SignUpForm())));
  }
}
