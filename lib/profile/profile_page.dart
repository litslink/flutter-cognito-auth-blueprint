import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/profile/edit/edit_page.dart';
import 'package:provider/provider.dart';
import '../data/repository/authentication_repository.dart';
import '../data/repository/user_repository.dart';
import '../sign_in/sign_in_page.dart';
import '../widgets/loading_indicator.dart';
import 'profile_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileBloc _profileBloc;

  @override
  Widget build(BuildContext context) {
    final authenticationRepository =
        Provider.of<AuthenticationRepository>(context);
    final userRepository = Provider.of<UserRepository>(context);
    _profileBloc = ProfileBloc(userRepository, authenticationRepository)
      ..add(LoadUser());

    _onSignOutPressed() {
      _profileBloc.add(SignOutUser());
    }

    return BlocListener<ProfileBloc, ProfileState>(
      bloc: _profileBloc,
      listener: (context, state) {
        if (state is UserLoadingFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (state is SignedOut) {
          Navigator.pushReplacementNamed(context, SignInPage.route);
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        bloc: _profileBloc,
        builder: (context, state) {
          return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(title: Text("Profile")),
              body: SingleChildScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 20.0),
                      width: 140.0,
                      height: 140.0,
                      child: CircleAvatar(
                          backgroundColor: Colors.amber,
                          radius: 25.0,
                          backgroundImage: state is UserLoaded
                              ? NetworkImage(state.user.picture)
                              : null),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: IconButton(
                        icon: Icon(Icons.edit),
                        iconSize: 32.0,
                        color: Colors.blue,
                        onPressed: () =>
                            Navigator.pushNamed(context, EditPage.route),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      state is UserLoaded ? state.user.name : "first name",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      state is UserLoaded ? state.user.familyName : "last name",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: RaisedButton(
                        onPressed: _onSignOutPressed,
                        child: Text('Sign out'),
                      )),
                  Container(
                    child: state is LoadingUser ? LoadingIndicator() : null,
                  ),
                ],
              )));
        },
      ),
    );
  }
}
