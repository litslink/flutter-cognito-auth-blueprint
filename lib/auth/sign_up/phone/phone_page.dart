import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/auth/sign_in/sign_in_page.dart';
import 'package:flutterapp/data/repository/authentication_repository.dart';
import 'package:flutterapp/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'phone_bloc.dart';
import 'phone_event.dart';
import 'phone_state.dart';

class PhoneSignUpPage extends StatefulWidget {
  static final String route = '/phoneSignUp';

  @override
  State<StatefulWidget> createState() => PhoneSignUpPageState();
}

class PhoneSignUpPageState extends State<PhoneSignUpPage> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmationCodeController = TextEditingController();
  PhoneSignUpBloc _phoneSignUpBloc;

  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmationCodeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _phoneSignUpBloc =
        PhoneSignUpBloc(Provider.of<AuthenticationRepository>(context));
    return Scaffold(
        body: Container(
            margin: EdgeInsets.only(top: 20.0),
            child: BlocListener<PhoneSignUpBloc, PhoneSignUpState>(
              bloc: _phoneSignUpBloc,
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
              child: BlocBuilder<PhoneSignUpBloc, PhoneSignUpState>(
                bloc: _phoneSignUpBloc,
                // ignore: missing_return
                builder: (context, state) {
                  if (state is SignUpConfirmation) {
                    return _buildConfirmationForm(state, state.isCodeValid);
                  } else if (state is SignUpRequired) {
                    return _buildSignUpForm(
                        state, state.isPhoneValid, state.isPasswordValid);
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
      PhoneSignUpState state, bool isEmailValid, bool isPasswordValid) {
    return Column(
      children: [
        TextField(
            controller: _phoneController,
            decoration: InputDecoration(
                labelText: 'phone',
                hintText: '+380501234567',
                errorText: isEmailValid ? null : 'enter valid phone number'),
            onChanged: (value) {
              _phoneSignUpBloc.add(PhoneChanged(value));
            },
            maxLines: 1,
            keyboardType: TextInputType.emailAddress),
        TextField(
            controller: _passwordController,
            decoration: InputDecoration(
                labelText: 'password',
                errorText: isPasswordValid ? null : 'enter valid password'),
            onChanged: (value) {
              _phoneSignUpBloc.add(PasswordChanged(value));
            },
            obscureText: true,
            maxLines: 1),
        RaisedButton(
          onPressed: () => _phoneSignUpBloc.add(
            SignUpButtonPressed(),
          ),
          child: Text('Sign up'),
        ),
        Container(
          child: state is SignUpLoading ? LoadingIndicator() : null,
        ),
        FlatButton(
            onPressed: () => _phoneSignUpBloc.add(SignInButtonPressed()),
            child: Text('Sign in'))
      ],
    );
  }

  Widget _buildConfirmationForm(PhoneSignUpState state, bool isCodeValid) {
    return Column(children: <Widget>[
      TextField(
        decoration: InputDecoration(
            labelText: 'confirmation code',
            errorText: isCodeValid ? null : 'enter valid code'),
        controller: _confirmationCodeController,
        onChanged: (value) {
          _phoneSignUpBloc.add(ConfirmationCodeChanged(value));
        },
        maxLength: 6,
        maxLines: 1,
      ),
      Container(
        child: state is SignUpLoading ? LoadingIndicator() : null,
      ),
      RaisedButton(
        onPressed: () => _phoneSignUpBloc.add(
          ConfirmSignUpPressed(),
        ),
        child: Text('Confirm sign up'),
      )
    ]);
  }
}
