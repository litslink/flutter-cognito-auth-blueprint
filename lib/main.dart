import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'auth/password_reset/password_reset_page.dart';
import 'auth/sign_in/phone/phone_page.dart';
import 'auth/sign_in/sign_in_page.dart';
import 'auth/sign_up/phone/phone_page.dart';
import 'auth/sign_up/sign_up_page.dart';
import 'base.dart';
import 'profile/edit/edit_page.dart';
import 'provider.dart';
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
            PasswordResetPage.route: (context) => PasswordResetPage(),
            SignUpPage.route: (context) => SignUpPage(),
            PhoneSignInPage.route: (context) => PhoneSignInPage(),
            PhoneSignUpPage.route: (context) => PhoneSignUpPage(),
            BasePage.route: (context) => BasePage(),
            EditPage.route: (context) => EditPage(),
          },
        ));
  }
}
