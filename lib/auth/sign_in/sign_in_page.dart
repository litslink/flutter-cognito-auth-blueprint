import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../base.dart';
import '../../data/repository/authentication_repository.dart';
import '../../widgets/loading_indicator.dart';
import '../password_reset/password_reset_page.dart';
import '../sign_up/phone/phone_page.dart';
import '../sign_up/sign_up_page.dart';
import 'phone/phone_page.dart';
import 'sign_in_bloc.dart';
import 'sign_in_event.dart';
import 'sign_in_state.dart';

class SignInPage extends StatefulWidget {
  static final String route = '/signIn';

  @override
  State<StatefulWidget> createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  SignInBloc _signInBloc;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext c) {
    _signInBloc = SignInBloc(Provider.of<AuthenticationRepository>(context));
    return Scaffold(
        body: Container(
            margin: EdgeInsets.only(top: 20.0),
            child: BlocListener<SignInBloc, LoginState>(
              bloc: _signInBloc,
              listener: (context, state) {
                if (state is SignInMovingToPhonePage) {
                  Navigator.of(context).pushNamed(PhoneSignInPage.route);
                } else if (state is SignInMovingToEmailSignUp) {
                  Navigator.of(context).pushNamed(SignUpPage.route);
                } else if (state is SignInMovingToPhoneSignUp) {
                  Navigator.of(context).pushNamed(PhoneSignUpPage.route);
                } else if (state is SignInSuccess) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      BasePage.route, (route) => false);
                } else if (state is SignInFailure) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Oops...something went wrong'),
                      backgroundColor: Colors.red));
                }
              },
              child: BlocBuilder<SignInBloc, LoginState>(
                bloc: _signInBloc,
                builder: (context, state) {
                  if (state is SignInRequired) {
                    return _buildSignInForm(
                        state, state.isEmailValid, state.isPasswordValid);
                  } else {
                    return _buildSignInForm(state, true, true);
                  }
                },
              ),
            )));
  }

  Widget _buildSignInForm(
      LoginState state, bool isEmailValid, bool isPasswordValid) {
    return Column(children: <Widget>[
      TextField(
          decoration: InputDecoration(
              labelText: 'email',
              errorText: isEmailValid ? null : 'enter valid email'),
          onChanged: (value) {
            _signInBloc.add(EmailChanged(value));
          },
          maxLines: 1,
          controller: _emailController,
          keyboardType: TextInputType.emailAddress),
      TextField(
          decoration: InputDecoration(
              labelText: 'password',
              errorText: isPasswordValid ? null : 'enter valid password'),
          onChanged: (value) {
            _signInBloc.add(PasswordChanged(value));
          },
          controller: _passwordController,
          obscureText: true,
          maxLines: 1),
      RaisedButton(
        onPressed: () => _signInBloc.add(
          SignInButtonPressed(),
        ),
        child: Text('Sign in'),
      ),
      Container(
        child: state is SignInLoading ? LoadingIndicator() : null,
      ),
      FlatButton(onPressed: _buildSignUpTypeDialog, child: Text('Sign up')),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () => _signInBloc.add(SignInWithPhonePressed()),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Icon(
                    Icons.phone_android,
                    size: 48,
                  )),
            ),
          ),
          GestureDetector(
            onTap: () => _signInBloc.add(
              SignInWithGooglePressed(),
            ),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Image.network(
                      'https://cdn0.iconfinder.com/data/icons/social-network-7/50/2-512.png')),
            ),
          ),
          GestureDetector(
            onTap: () => _signInBloc.add(
              SignInWithFacebookPressed(),
            ),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Image.network(
                      'https://cdn3.iconfinder.com/data/icons/capsocial-round/500/facebook-512.png')),
            ),
          )
        ],
      ),
      GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(PasswordResetPage.route),
        child: Text('Reset password',
            style: TextStyle(fontSize: 16, color: Colors.blueAccent)),
      ),
    ]);
  }

  Future<void> _buildSignUpTypeDialog() async {
    await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Select the way to sign up"),
              content: Text("What do you want to use as username?"),
              actions: <Widget>[
                MaterialButton(
                  child: Text("Email"),
                  onPressed: () {
                    Navigator.pop(context);
                    _signInBloc.add(SignUpWithEmailPressed());
                  },
                ),
                MaterialButton(
                  child: Text("Phone"),
                  onPressed: () {
                    Navigator.pop(context);
                    _signInBloc.add(SignUpWithPhonePressed());
                  },
                )
              ],
            ));
  }
}
