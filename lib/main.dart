import 'package:bloc/bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'base.dart';
import 'provider.dart';
import 'sign_in/sign_in_page.dart';
import 'sign_up/sign_up_page.dart';
import 'splash/splash_page.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print('$error, $stacktrace');
  }
}

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(CognitoApp());
}

class CognitoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: providers,
        child: MaterialApp(
          initialRoute: SplashPage.route,
          routes: {
            SplashPage.route: (context) => SplashPage(),
            SignInPage.route: (context) => SignInPage(),
            SignUpPage.route: (context) => SignUpPage(),
            BasePage.route: (context) => BasePage()
          },
        ));
  }
}
