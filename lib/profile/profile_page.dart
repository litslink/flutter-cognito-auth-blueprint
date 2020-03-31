import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../auth/sign_in/sign_in_page.dart';
import '../data/repository/authentication_repository.dart';
import '../data/repository/user_repository.dart';
import '../widgets/loading_indicator.dart';
import 'edit/edit_page.dart';
import 'profile_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileBloc _profileBloc;
  bool _isNotificationOn = false;

  @override
  Widget build(BuildContext context) {
    final authenticationRepository =
        Provider.of<AuthenticationRepository>(context);
    final userRepository = Provider.of<UserRepository>(context);
    _profileBloc = ProfileBloc(userRepository, authenticationRepository)
      ..add(LoadUser());
    return Scaffold(
        appBar: AppBar(title: Text("Profile")),
        body: BlocListener<ProfileBloc, ProfileState>(
          bloc: _profileBloc,
          listener: (context, state) {
            if (state is UserLoadingFailure) {
              Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Oops...something went wrong'),
                  backgroundColor: Colors.red));
            }
            if (state is SignedOut) {
              Navigator.pushReplacementNamed(context, SignInPage.route);
            }
          },
          child: BlocBuilder<ProfileBloc, ProfileState>(
            bloc: _profileBloc,
            builder: (context, state) => _buildProfile(state),
          ),
        ));
  }

  Widget _buildProfile(ProfileState state) {
    return SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 20.0),
            width: 100.0,
            height: 100.0,
            child: CircleAvatar(
                backgroundColor: Colors.amber,
                radius: 25.0,
                backgroundImage: state is UserLoaded
                    ? NetworkImage(state.user.picture)
                    : null),
          ),
        ),
        Container(
          child: state is LoadingUser ? LoadingIndicator() : null,
        ),
        Padding(
            padding: const EdgeInsets.all(20.0),
            child: RaisedButton(
              onPressed: () => state is UserLoaded
                  ? Navigator.of(context)
                      .pushNamed(EditPage.route, arguments: state.user)
                  : null,
              child: Text('Edit'),
            )),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            state is UserLoaded ? state.user.name : "first name",
            style: TextStyle(fontSize: 18),
          ),
        ),
        Divider(height: 1.0, color: Colors.blue),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            state is UserLoaded ? state.user.familyName : "last name",
            style: TextStyle(fontSize: 18),
          ),
        ),
        Divider(height: 1.0, color: Colors.blue),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Notifications',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              Switch(
                value: _isNotificationOn,
                onChanged: (value) {
                  setState(() {
                    _isNotificationOn = value;
                  });
                },
              ),
            ],
          ),
        ),
        Divider(height: 1.0, color: Colors.blue),
        Padding(
            padding: const EdgeInsets.all(20.0),
            child: RaisedButton(
              onPressed: _onSignOutPressed,
              child: Text('Sign out'),
            )),
      ],
    ));
  }

  void _onSignOutPressed() {
    _profileBloc.add(SignOutUser());
  }
}
