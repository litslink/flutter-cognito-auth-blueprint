import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../data/model/user.dart';
import '../../data/repository/user_repository.dart';
import '../../widgets/loading_indicator.dart';
import 'edit_bloc.dart';
import 'edit_event.dart';
import 'edit_state.dart';

class EditPage extends StatefulWidget {
  static final String route = '/edit';

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  File _imgFile;
  EditBloc _editBloc;
  final _editNameController = TextEditingController();
  final _editLastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context).settings.arguments as User;
    _editNameController.text = user.name;
    _editLastNameController.text = user.familyName;
    final userRepository = Provider.of<UserRepository>(context);
    _editBloc = EditBloc(userRepository);
    return Scaffold(
        body: BlocListener<EditBloc, EditState>(
      bloc: _editBloc,
      listener: (context, state) {
        if (state is Edited) {
          Navigator.pop(context);
        }
        if (state is EditFailure) {
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Oops...something went wrong'),
              backgroundColor: Colors.red));
        }
      },
      child: BlocBuilder<EditBloc, EditState>(
        bloc: _editBloc,
        builder: (context, state) {
          if (state is PicturePicked) {
            _imgFile = state.image;
          }
          if (state is EditRequired) {
            return _buildScreen(
                state, user, state.isFirstNameValid, state.isLastNameValid);
          } else {
            return _buildScreen(state, user, true, true);
          }
        },
      ),
    ));
  }

  Widget _buildScreen(
      EditState state, User user, bool isFirstNameValid, bool isLastNameValid) {
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
                width: 100.0,
                height: 100.0,
                child: CircleAvatar(
                    backgroundColor: Colors.amber,
                    radius: 25.0,
                    backgroundImage: _buildAvatar(state, user),
                    child: _imgFile == null && user.picture == null
                        ? Icon(Icons.camera_alt, color: Colors.white)
                        : null),
              ),
            )),
            Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                      labelText: 'first name',
                      errorText:
                          isFirstNameValid ? null : 'field must not be emty'),
                  controller: _editNameController,
                  onChanged: (value) {
                    _editBloc.add(FirstNameChanged(_editNameController.text));
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                      labelText: 'last name',
                      errorText:
                          isLastNameValid ? null : 'field must not be emty'),
                  controller: _editLastNameController,
                  onChanged: (value) {
                    _editBloc.add(LastNameChanged(value));
                  },
                ),
                RaisedButton(
                  onPressed: () {
                    _editBloc.add(FirstNameChanged(_editNameController.text));
                    _editBloc
                        .add(LastNameChanged(_editLastNameController.text));
                    _editBloc.add(
                      UpdateButtonPressed(
                          picUrl: _imgFile != null ? _imgFile.path : ""),
                    );
                  },
                  child: Text('Update'),
                ),
                Container(
                  child: state is Loading ? LoadingIndicator() : null,
                ),
              ],
            ),
          ],
        )));
  }

  void _onPicPressed(ImageSource imageSource) {
    Navigator.pop(context);
    _editBloc.add(
      PicPressed(imageSource: imageSource),
    );
  }

  ImageProvider _buildAvatar(EditState state, User user) {
    if (state is PicturePicked) {
      return FileImage(state.image);
    } else if (_imgFile != null) {
      return FileImage(_imgFile);
    } else if (state is EditRequired) {
      return NetworkImage(user.picture);
    }
    return NetworkImage("");
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
