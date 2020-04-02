import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../base.dart';
import '../../../data/repository/authentication_repository.dart';
import '../../../widgets/loading_indicator.dart';
import 'phone_bloc.dart';
import 'phone_event.dart';
import 'phone_state.dart';

class PhoneSignInPage extends StatefulWidget {
  static final String route = '/phoneSignIn';

  @override
  State<StatefulWidget> createState() => PhoneSignInPageState();
}

class PhoneSignInPageState extends State<PhoneSignInPage> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmationCodeController = TextEditingController();
  PhoneSignInBloc _phoneSignInBloc;

  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmationCodeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _phoneSignInBloc =
        PhoneSignInBloc(Provider.of<AuthenticationRepository>(context));
    return Scaffold(
        body: Container(
            margin: EdgeInsets.only(top: 20.0),
            child: BlocListener<PhoneSignInBloc, PhoneSignInState>(
              bloc: _phoneSignInBloc,
              listener: (context, state) {
                if (state is SignInSuccess) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      BasePage.route, (route) => false);
                } else if (state is SignInFailure) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Oops...something went wrong'),
                      backgroundColor: Colors.red));
                }
              },
              child: BlocBuilder<PhoneSignInBloc, PhoneSignInState>(
                bloc: _phoneSignInBloc,
                builder: (context, state) {
                  if (state is SignInRequired) {
                    return _buildSignInForm(
                        state, state.isPhoneValid, state.isPasswordValid);
                  } else {
                    return _buildSignInForm(state, true, true);
                  }
                },
              ),
            )));
  }

  Widget _buildSignInForm(
      PhoneSignInState state, bool isEmailValid, bool isPasswordValid) {
    return Column(
      children: [
        TextField(
            controller: _phoneController,
            decoration: InputDecoration(
                labelText: 'phone',
                hintText: '+380501234567',
                errorText: isEmailValid ? null : 'enter valid phone number'),
            onChanged: (value) {
              _phoneSignInBloc.add(PhoneChanged(value));
            },
            maxLines: 1,
            keyboardType: TextInputType.emailAddress),
        TextField(
            controller: _passwordController,
            decoration: InputDecoration(
                labelText: 'password',
                errorText: isPasswordValid ? null : 'enter valid password'),
            onChanged: (value) {
              _phoneSignInBloc.add(PasswordChanged(value));
            },
            obscureText: true,
            maxLines: 1),
        RaisedButton(
          onPressed: () => _phoneSignInBloc.add(
            SignInButtonPressed(),
          ),
          child: Text('Sign in'),
        ),
        Container(
          child: state is SignInLoading ? LoadingIndicator() : null,
        ),
      ],
    );
  }
}
