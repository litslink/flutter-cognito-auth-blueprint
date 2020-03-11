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
  final _signUpKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _onSignUpButtonPressed() {
      if (_signUpKey.currentState.validate()) {
        BlocProvider.of<SignUpBloc>(context).add(
          SignUpButtonPressed(
            username: _emailController.text,
            password: _passwordController.text,
          ),
        );
      }
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
            key: _signUpKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'email'),
                  maxLines: 1,
                  controller: _emailController,
                  validator: (value) =>
                      value.isEmpty ? "Enter your email!" : null,
                  keyboardType: TextInputType.emailAddress,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'password'),
                  controller: _passwordController,
                  obscureText: true,
                  validator: (value) => value.length < 8
                      ? "Password length can\'t be lower than 8 characters"
                      : null,
                  maxLines: 1,
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
