import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../auth/sign_in/sign_in_page.dart';
import '../base.dart';
import '../data/repository/authentication_repository.dart';
import 'splash_bloc.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashPage extends StatelessWidget {
  static final String route = '/';

  @override
  Widget build(BuildContext context) {
    final authenticationRepository =
        Provider.of<AuthenticationRepository>(context);
    return Scaffold(
      body: BlocProvider(
        create: (context) =>
            SplashBloc(authenticationRepository)..add(CheckAuthentication()),
        child: BlocListener<SplashBloc, SplashState>(
          listener: (context, state) {
            if (state is Authenticated) {
              Navigator.of(context).pushReplacementNamed(BasePage.route);
            } else if (state is AuthenticationRequired) {
              Navigator.of(context).pushReplacementNamed(SignInPage.route);
            }
          },
          child: Center(child: Text("Cognito blueprint")),
        ),
      ),
    );
  }
}
