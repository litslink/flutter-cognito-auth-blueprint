import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'sign_up_bloc.dart';
import 'sign_up_event.dart';
import 'sign_up_state.dart';

class SignUpForm extends StatefulWidget {
  @override
  State<SignUpForm> createState() => _SignUpForm();
}

class _SignUpForm extends State<SignUpForm> {
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _onSignUpButtonPressed() {
      BlocProvider.of<SignUpBloc>(context).add(
        SignUpButtonPressed(
          username: _loginController.text,
          password: _passwordController.text,
        ),
      );
    }

    _onSignInButtonPressed() {
      BlocProvider.of<SignUpBloc>(context).add(
        SignInButtonPressed(),
      );
    }

    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<SignUpBloc, SignUpState>(
        builder: (context, state) {
          return Form(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'login'),
                  controller: _loginController,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'password'),
                  controller: _passwordController,
                  obscureText: true,
                ),
                RaisedButton(
                  onPressed:
                      state is! SignUpLoading ? _onSignUpButtonPressed : null,
                  child: Text('Sign up'),
                ),
                Container(
                  child: state is SignUpLoading
                      ? CircularProgressIndicator()
                      : null,
                ),
                FlatButton(
                    onPressed:
                    state is! SignUpLoading ? _onSignInButtonPressed : null,
                    child: Text('Sign in'))
              ],
            ),
          );
        },
      ),
    );
  }
}
