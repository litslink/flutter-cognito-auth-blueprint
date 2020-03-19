import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../base.dart';
import '../data/repository/authentication_repository.dart';
import '../sign_up/sign_up_page.dart';
import '../validation/validation_bloc.dart';
import '../validation/validation_event.dart';
import '../validation/validation_state.dart';
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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmationKey = GlobalKey<FormState>();
  final _usernameKey = GlobalKey<FormState>();
  final _resetUsernameController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmationCodeController = TextEditingController();
  SignInBloc _signInBloc;
  ValidationBloc _validationBloc;
  bool _isSignUpButtonActive = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _resetUsernameController.dispose();
    _newPasswordController.dispose();
    _confirmationCodeController.dispose();
  }

  @override
  Widget build(BuildContext c) {
    _signInBloc = SignInBloc(Provider.of<AuthenticationRepository>(context));
    _validationBloc = ValidationBloc();

    return Scaffold(
        body: MultiBlocProvider(
            providers: [
          BlocProvider<SignInBloc>(
            create: (context) {
              return _signInBloc;
            },
          ),
          BlocProvider<ValidationBloc>(
            create: (context) {
              return _validationBloc;
            },
          ),
        ],
            child: Container(
                margin: EdgeInsets.only(top: 20.0),
                child: MultiBlocListener(
                  listeners: [
                    BlocListener<SignInBloc, LoginState>(
                      bloc: _signInBloc,
                      listener: (context, state) {
                        if (state is SignInMovingToSignUp) {
                          Navigator.of(context).pushNamed(SignUpPage.route);
                        } else if (state is SignInSuccess) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              BasePage.route, (route) => false);
                        } else if (state is SignInFailure) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('Oops...something went wrong'),
                            backgroundColor: Colors.red
                          ));
                        }
                      },
                    ),
                    BlocListener<ValidationBloc, ValidationState>(
                      bloc: _validationBloc,
                      listener: (context, state) {
                        if (state is FieldsNotEmpty) {
                          _validateSignIn();
                        }
                        setState(() {
                          _isSignUpButtonActive =
                              state is FieldsValidated ? true : false;
                        });
                      },
                    )
                  ],
                  child: BlocBuilder<SignInBloc, LoginState>(
                    builder: (context, state) {
                      if (state is ResetPassword) {
                        return _buildResetForm();
                      }
                      if (state is ConfirmationCode) {
                        return _buildConfirmationForm();
                      } else {
                        return _buildSignInForm(state);
                      }
                    },
                  ),
                ))));
  }

  Widget _buildSignInForm(LoginState state) {
    return Column(children: <Widget>[
      TextFormField(
          decoration: InputDecoration(labelText: 'email'),
          maxLines: 1,
          controller: _emailController,
          keyboardType: TextInputType.emailAddress),
      TextFormField(
          decoration: InputDecoration(labelText: 'password'),
          controller: _passwordController,
          obscureText: true,
          maxLines: 1),
      RaisedButton(
        onPressed: _isSignUpButtonActive ? _onSignInButtonPressed : null,
        child: Text('Sign in'),
      ),
      Container(
        child: state is SignInLoading ? LoadingIndicator() : null,
      ),
      FlatButton(onPressed: _onSignUpButtonPressed, child: Text('Sign up')),
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
            onTap: _onSignInWithGoogleButtonPressed,
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
            onTap: _onSignInWithFacebookButtonPressed,
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
          onPressed: _onResetButtonPressed, child: Text('Reset password'))
    ]);
  }

  Widget _buildResetForm() {
    return Form(
        key: _usernameKey,
        child: Column(children: <Widget>[
          TextFormField(
              decoration: InputDecoration(labelText: 'email'),
              maxLines: 1,
              controller: _resetUsernameController,
              validator: (value) => value.isEmpty ? "Enter your email!" : null,
              keyboardType: TextInputType.emailAddress),
          RaisedButton(
            onPressed: _onGetCodeButtonPressed,
            child: Text('proceed'),
          )
        ]));
  }

  Widget _buildConfirmationForm() {
    return Form(
        key: _confirmationKey,
        child: Column(children: <Widget>[
          TextFormField(
              decoration: InputDecoration(labelText: 'new password'),
              controller: _newPasswordController,
              obscureText: true,
              validator: (value) => value.length < 8
                  ? "Password length can\'t be lower than 8"
                      " characters"
                  : null,
              maxLines: 1),
          TextFormField(
            decoration: InputDecoration(labelText: 'confirmation code'),
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
  }

  void _onSignInButtonPressed() {
    _signInBloc.add(
      SignInButtonPressed(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  void _onSignInWithGoogleButtonPressed() {
    _signInBloc.add(
      SignInWithGooglePressed(),
    );
  }

  void _onSignInWithFacebookButtonPressed() {
    _signInBloc.add(
      SignInWithFacebookPressed(),
    );
  }

  void _onSignUpButtonPressed() {
    _signInBloc.add(
      SignUpButtonPressed(),
    );
  }

  void _onResetButtonPressed() {
    _signInBloc.add(
      ResetButtonPressed(),
    );
  }

  void _onGetCodeButtonPressed() {
    _signInBloc.add(
      GetConfirmationCodePressed(username: _resetUsernameController.text),
    );
  }

  void _onConfirmResetButtonPressed() {
    _signInBloc.add(
      ConfirmResetButtonPressed(
          username: _resetUsernameController.text,
          newPassword: _newPasswordController.text,
          code: _confirmationCodeController.text),
    );
  }

  void _onEmailChanged() {
    _validationBloc.add(FieldChanged(field: _emailController.text));
  }

  void _onPasswordChanged() {
    _validationBloc.add(FieldChanged(field: _passwordController.text));
  }

  void _validateSignIn() {
    if (_validationBloc.isEmailValid(_emailController.text) &&
        _validationBloc.isPasswordValid(_passwordController.text)) {
      _validationBloc.add(ValidationSuccess(
          email: _emailController.text, password: _passwordController.text));
    } else {
      _validationBloc.add(ValidationFailed(
          email: _emailController.text, password: _passwordController.text));
    }
  }
}
