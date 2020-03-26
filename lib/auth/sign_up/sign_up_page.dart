import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../data/repository/authentication_repository.dart';
import '../../widgets/loading_indicator.dart';
import '../sign_in/sign_in_page.dart';
import 'sign_up_bloc.dart';
import 'sign_up_event.dart';
import 'sign_up_state.dart';

class SignUpPage extends StatefulWidget {
  static final String route = '/signUp';

  @override
  State<StatefulWidget> createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmationCodeController = TextEditingController();
  SignUpBloc _signUpBloc;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmationCodeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _signUpBloc = SignUpBloc(Provider.of<AuthenticationRepository>(context));
    return Scaffold(
        body: Container(
            margin: EdgeInsets.only(top: 20.0),
            child: BlocListener<SignUpBloc, SignUpState>(
              bloc: _signUpBloc,
              listener: (context, state) {
                if (state is SignUpMovingToSignIn) {
                  Navigator.of(context).pop();
                } else if (state is SignUpSuccess) {
                  Navigator.of(context).popAndPushNamed(SignInPage.route);
                } else if (state is SignUpFailure) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Oops...something went wrong'),
                      backgroundColor: Colors.red));
                }
              },
              child: BlocBuilder<SignUpBloc, SignUpState>(
                bloc: _signUpBloc,
                // ignore: missing_return
                builder: (context, state) {
                  if (state is SignUpConfirmation) {
                    return _buildConfirmationForm(state, state.isCodeValid);
                  } else if (state is SignUpRequired) {
                    return _buildSignUpForm(
                        state, state.isEmailValid, state.isPasswordValid);
                  } else if (state is SignUpLoading) {
                    return _buildSignUpForm(state, true, true);
                  } else if (state is ConfirmationLoading) {
                    return _buildConfirmationForm(state, true);
                  } else if (state is SignUpSuccess) {
                    return _buildConfirmationForm(state, true);
                  } else if (state is SignUpMovingToSignIn) {
                    return _buildSignUpForm(state, true, true);
                  }
                },
              ),
            )));
  }

  Widget _buildSignUpForm(
      SignUpState state, bool isEmailValid, bool isPasswordValid) {
    return Column(
      children: [
        TextField(
            controller: _emailController,
            decoration: InputDecoration(
                labelText: 'email',
                errorText: isEmailValid ? null : 'enter valid email'),
            onChanged: (value) {
              _signUpBloc.add(EmailChanged(value));
            },
            maxLines: 1,
            keyboardType: TextInputType.emailAddress),
        TextField(
            controller: _passwordController,
            decoration: InputDecoration(
                labelText: 'password',
                errorText: isPasswordValid ? null : 'enter valid password'),
            onChanged: (value) {
              _signUpBloc.add(PasswordChanged(value));
            },
            obscureText: true,
            maxLines: 1),
        RaisedButton(
          onPressed: () => _signUpBloc.add(
            SignUpButtonPressed(),
          ),
          child: Text('Sign up'),
        ),
        Container(
          child: state is SignUpLoading ? LoadingIndicator() : null,
        ),
        FlatButton(
            onPressed: () => _signUpBloc.add(SignInButtonPressed()),
            child: Text('Sign in'))
      ],
    );
  }

  Widget _buildConfirmationForm(SignUpState state, bool isCodeValid) {
    return Column(children: <Widget>[
      TextField(
        decoration: InputDecoration(
            labelText: 'confirmation code',
            errorText: isCodeValid ? null : 'enter valid code'),
        controller: _confirmationCodeController,
        onChanged: (value) {
          _signUpBloc.add(ConfirmationCodeChanged(value));
        },
        maxLength: 6,
        maxLines: 1,
      ),
      Container(
        child: state is SignUpLoading ? LoadingIndicator() : null,
      ),
      RaisedButton(
        onPressed: () => _signUpBloc.add(
          ConfirmSignUpPressed(),
        ),
        child: Text('Confirm sign up'),
      )
    ]);
  }
}
