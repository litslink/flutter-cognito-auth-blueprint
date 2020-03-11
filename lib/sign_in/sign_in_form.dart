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
  final _signInKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _onSignInButtonPressed() {
      if (_signInKey.currentState.validate()) {
        BlocProvider.of<SignInBloc>(context).add(
          SignInButtonPressed(
            username: _emailController.text,
            password: _passwordController.text,
          ),
        );
      }
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
            key: _signInKey,
            child: Column(
              children: [
                TextFormField(
                    decoration: InputDecoration(labelText: 'email'),
                    maxLines: 1,
                    controller: _emailController,
                    validator: (value) =>
                        value.isEmpty ? "Enter your email!" : null,
                    keyboardType: TextInputType.emailAddress),
                TextFormField(
                    decoration: InputDecoration(labelText: 'password'),
                    controller: _passwordController,
                    obscureText: true,
                    validator: (value) => value.length < 8
                        ? "Password length can\'t be lower than 8 characters"
                        : null,
                    maxLines: 1),
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
