import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../base.dart';
import '../data/repository/authentication_repository.dart';
import '../sign_up/sign_up_page.dart';
import '../widgets/loading_indicator.dart';
import 'sign_in_bloc.dart';
import 'sign_in_event.dart';
import 'sign_in_state.dart';

class SignInPage extends StatefulWidget {
  static final String route = '/signIn';

  @override
  State<StatefulWidget> createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  final _signInKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmationKey = GlobalKey<FormState>();
  final _usernameKey = GlobalKey<FormState>();
  final _resetUsernameController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmationCodeController = TextEditingController();
  SignInBloc _signInBloc;

  @override
  Widget build(BuildContext context) {
    _signInBloc = SignInBloc(Provider.of<AuthenticationRepository>(context));
    _onSignInButtonPressed() {
      if (_signInKey.currentState.validate()) {
        _signInBloc.add(
          SignInButtonPressed(
            email: _emailController.text,
            password: _passwordController.text,
          ),
        );
      }
    }

    _onSignUpButtonPressed() {
      _signInBloc.add(
        SignUpButtonPressed(),
      );
    }

    _onResetButtonPressed() {
      _signInBloc.add(
        ResetButtonPressed(),
      );
    }

    _onGetCodeButtonPressed() {
      _signInBloc.add(
        GetConfirmationCodePressed(username: _resetUsernameController.text),
      );
    }

    _onConfirmResetButtonPressed() {
      _signInBloc.add(
        ConfirmResetButtonPressed(
            username: _resetUsernameController.text,
            newPassword: _newPasswordController.text,
            code: _confirmationCodeController.text),
      );
    }

    return Material(
        child: BlocProvider(
            create: (context) {
              return _signInBloc;
            },
            child: Container(
                margin: EdgeInsets.only(top: 20.0),
                child: BlocListener<SignInBloc, LoginState>(
                  bloc: _signInBloc,
                  listener: (context, state) {
                    if (state is SignInMovingToSignUp) {
                      Navigator.of(context).popAndPushNamed(SignUpPage.route);
                    } else if (state is SignInSuccess) {
                      Navigator.of(context)
                          .pushReplacementNamed(BasePage.route);
                    } else if (state is SignInFailure) {
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${state.toString()}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: BlocBuilder<SignInBloc, LoginState>(
                    builder: (context, state) {
                      if (state is ResetPassword) {
                        return Form(
                            key: _usernameKey,
                            child: Column(children: <Widget>[
                              TextFormField(
                                  decoration:
                                      InputDecoration(labelText: 'email'),
                                  maxLines: 1,
                                  controller: _resetUsernameController,
                                  validator: (value) => value.isEmpty
                                      ? "Enter your email!"
                                      : null,
                                  keyboardType: TextInputType.emailAddress),
                              RaisedButton(
                                onPressed: _onGetCodeButtonPressed,
                                child: Text('proceed'),
                              )
                            ]));
                      } else if (state is ConfirmationCode) {
                        return Form(
                            key: _confirmationKey,
                            child: Column(children: <Widget>[
                              TextFormField(
                                  decoration: InputDecoration(
                                      labelText: 'new password'),
                                  controller: _newPasswordController,
                                  obscureText: true,
                                  validator: (value) => value.length < 8
                                      ? "Password length can\'t be lower than 8"
                                          " characters"
                                      : null,
                                  maxLines: 1),
                              TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'confirmation code'),
                                controller: _confirmationCodeController,
                                maxLength: 6,
                                validator: (value) => value.length != 6
                                    ? "Confirmation code consists of 6 digits"
                                    : null,
                                maxLines: 1,
                              ),
                              RaisedButton(
                                onPressed: _onConfirmResetButtonPressed,
                                child: Text('Confirm password reset'),
                              )
                            ]));
                      } else {
                        return Column(children: <Widget>[
                          Form(
                            key: _signInKey,
                            child: Column(
                              children: [
                                TextFormField(
                                    decoration:
                                        InputDecoration(labelText: 'email'),
                                    maxLines: 1,
                                    controller: _emailController,
                                    validator: (value) => value.isEmpty
                                        ? "Enter your email!"
                                        : null,
                                    keyboardType: TextInputType.emailAddress),
                                TextFormField(
                                    decoration:
                                        InputDecoration(labelText: 'password'),
                                    controller: _passwordController,
                                    obscureText: true,
                                    validator: (value) => value.length < 8
                                        ? "Password length can\'t be lower than 8"
                                            " characters"
                                        : null,
                                    maxLines: 1),
                                RaisedButton(
                                  onPressed: _onSignInButtonPressed,
                                  child: Text('Sign in'),
                                ),
                                Container(
                                  child: state is SignInLoading
                                      ? LoadingIndicator()
                                      : null,
                                ),
                                FlatButton(
                                    onPressed: _onSignUpButtonPressed,
                                    child: Text('Sign up'))
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: null,
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
                                onTap: null,
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
                                onTap: () {},
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
                          FlatButton(
                              onPressed: _onResetButtonPressed,
                              child: Text('Reset password'))
                        ]);
                      }
                    },
                  ),
                ))));
  }
}
