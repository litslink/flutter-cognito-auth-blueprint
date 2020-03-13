import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
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
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  String _picUrl;
  ProfileBloc _profileBloc;

  @override
  Widget build(BuildContext context) {
    final authenticationRepository =
        Provider.of<AuthenticationRepository>(context);
    final userRepository = Provider.of<UserRepository>(context);
    _profileBloc = ProfileBloc(userRepository, authenticationRepository)
      ..add(LoadUser());
    _onUpdateButtonPressed() {
      _profileBloc.add(
        UpdateButtonPressed(
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            picUrl: _picUrl),
      );
    }

    _onSignOutPressed() {
      _profileBloc.add(SignOutUser());
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
                children: <Widget>[
                  Center(
                      child: InkWell(
                    onTap: _buildImagePickerDialog,
                    child: Container(
                      margin: EdgeInsets.only(top: 20.0),
                      width: 140.0,
                      height: 140.0,
                      child: CircleAvatar(
                          backgroundColor: Colors.amber,
                          radius: 25.0,
                          backgroundImage: state is PicturePicked
                              ? FileImage(state.image)
                              : null,
                          child: state is! PicturePicked
                              ? Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                )
                              : null),
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
                        ),
                        RaisedButton(
                          onPressed: _onUpdateButtonPressed,
                          child: Text('Update'),
                        ),
                        RaisedButton(
                          onPressed: _onSignOutPressed,
                          child: Text('Sign out'),
                        ),
                        Container(
                          child: state is EditingLoading
                              ? LoadingIndicator()
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

  void _onPicPressed(ImageSource imageSource) {
    Navigator.pop(context);
    _profileBloc.add(
      PicPressed(imageSource: imageSource),
    );
  }

  Future<void> _buildImagePickerDialog() async {
    await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Select the image source"),
              actions: <Widget>[
                MaterialButton(
                  child: Text("Camera"),
                  onPressed: () => _onPicPressed(ImageSource.camera),
                ),
                MaterialButton(
                  child: Text("Gallery"),
                  onPressed: () => _onPicPressed(ImageSource.gallery),
                )
              ],
            ));
  }
}
