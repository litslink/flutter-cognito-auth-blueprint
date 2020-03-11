import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repository/user_repository.dart';
import 'profile_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  String _picUrl;
  final ProfileBloc _profileBloc = ProfileBloc(UserRepository());

  @override
  Widget build(BuildContext context) {
    _onUpdateButtonPressed() {
      _profileBloc.add(
        UpdateButtonPressed(
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            picUrl: _picUrl),
      );
    }

    _onPicPressed() {
      _profileBloc.add(
        PicPressed(),
      );
    }

    return BlocListener<ProfileBloc, ProfileState>(
      bloc: _profileBloc,
      listener: (context, state) {
        if (state is EditingFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
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
                children: <Widget>[
                  Center(
                      child: InkWell(
                    onTap: _onPicPressed,
                    child: Container(
                      margin: EdgeInsets.only(top: 20.0),
                      width: 140.0,
                      height: 140.0,
                      child: CircleAvatar(
                          backgroundColor: Colors.amber,
                          radius: 25.0,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          )),
                    ),
                  )),
                  Form(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(labelText: 'first name'),
                          controller: _firstNameController,
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'last name'),
                          controller: _lastNameController,
                          obscureText: true,
                        ),
                        RaisedButton(
                          onPressed: () => state is! EditingLoading
                              ? _onUpdateButtonPressed()
                              : null,
                          child: Text('Update'),
                        ),
                        Container(
                          child: state is EditingLoading
                              ? CircularProgressIndicator()
                              : null,
                        ),
                      ],
                    ),
                  )
                ],
              )));
        },
      ),
    );
  }
}
