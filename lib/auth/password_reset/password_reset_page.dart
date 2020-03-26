import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../data/repository/authentication_repository.dart';
import '../sign_in/sign_in_page.dart';
import 'password_reset_bloc.dart';
import 'password_reset_event.dart';
import 'password_reset_state.dart';

class PasswordResetPage extends StatefulWidget {
  static final String route = '/passwordReset';

  @override
  State<StatefulWidget> createState() => PasswordResetPageState();
}

class PasswordResetPageState extends State<PasswordResetPage> {
  PasswordResetBloc _passwordResetBloc;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmationCodeController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmationCodeController.dispose();
  }

  @override
  Widget build(BuildContext c) {
    final authenticationRepository =
        Provider.of<AuthenticationRepository>(context);
    _passwordResetBloc = PasswordResetBloc(authenticationRepository);
    return Scaffold(
        appBar: AppBar(title: Text("Reset password")),
        body: BlocListener<PasswordResetBloc, PasswordResetState>(
          bloc: _passwordResetBloc,
          listener: (context, state) {
            if (state is ResetSuccess) {
              Navigator.popAndPushNamed(context, SignInPage.route);
            } else if (state is ResetFailure) {
              Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Oops...something went wrong'),
                  backgroundColor: Colors.red));
            }
          },
          child: BlocBuilder<PasswordResetBloc, PasswordResetState>(
            bloc: _passwordResetBloc,
            // ignore: missing_return
            builder: (context, state) {
              if (state is ConfirmReset) {
                return _buildConfirmationForm(
                    context, state.isPasswordValid, state.isCodeValid);
              } else if (state is ResetRequired) {
                return _buildResetForm(context, state.isEmailValid);
              } else if (state is GettingConfirmationCode) {
                return _buildResetForm(context, true);
              } else if (state is ResetLoading) {
                return _buildConfirmationForm(context, true, true);
              }
            },
          ),
        ));
  }

  Widget _buildResetForm(
    BuildContext context,
    bool isEmailValid,
  ) {
    return Column(children: <Widget>[
      TextField(
          controller: _emailController,
          decoration: InputDecoration(
              labelText: 'email',
              errorText: isEmailValid ? null : 'enter valid email'),
          onChanged: (value) {
            _passwordResetBloc.add(EmailChanged(value));
          },
          maxLines: 1,
          keyboardType: TextInputType.emailAddress),
      RaisedButton(
        onPressed: () {
          _passwordResetBloc.add(
            GetConfirmationCodePressed(),
          );
        },
        child: Text('proceed'),
      )
    ]);
  }

  Widget _buildConfirmationForm(
      BuildContext context, bool isPasswordValid, bool isCodeValid) {
    return Column(children: <Widget>[
      TextField(
          controller: _passwordController,
          decoration: InputDecoration(
              labelText: 'new password',
              errorText: isPasswordValid ? null : 'enter valid password'),
          onChanged: (value) {
            _passwordResetBloc.add(PasswordChanged(value));
          },
          obscureText: true,
          maxLines: 1),
      TextField(
        controller: _confirmationCodeController,
        decoration: InputDecoration(
            labelText: 'confirmation code',
            errorText: isCodeValid ? null : 'enter valid code'),
        onChanged: (value) {
          _passwordResetBloc.add(ConfirmationCodeChanged(value));
        },
        maxLength: 6,
        maxLines: 1,
      ),
      RaisedButton(
        onPressed: () {
          _passwordResetBloc.add(
            ConfirmResetButtonPressed(),
          );
        },
        child: Text('Confirm password reset'),
      )
    ]);
  }
}
