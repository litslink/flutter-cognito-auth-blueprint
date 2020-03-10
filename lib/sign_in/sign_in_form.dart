import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'sign_in_bloc.dart';
import 'sign_in_event.dart';
import 'sign_in_state.dart';

class SignInForm extends StatefulWidget {
  @override
  State<SignInForm> createState() => _SignInForm();
}

class _SignInForm extends State<SignInForm> {
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _onSignInButtonPressed() {
      BlocProvider.of<SignInBloc>(context).add(
        SignInButtonPressed(
          username: _loginController.text,
          password: _passwordController.text,
        ),
      );
    }

    _onSignUpButtonPressed() {
      BlocProvider.of<SignInBloc>(context).add(
        SignUpButtonPressed(),
      );
    }

    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignInFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<SignInBloc, SignInState>(
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
                      state is! SignInLoading ? _onSignInButtonPressed : null,
                  child: Text('Sign in'),
                ),
                Container(
                  child: state is SignInLoading
                      ? CircularProgressIndicator()
                      : null,
                ),
                FlatButton(
                    onPressed:
                        state is! SignInLoading ? _onSignUpButtonPressed : null,
                    child: Text('Sign up'))
              ],
            ),
          );
        },
      ),
    );
  }
}
