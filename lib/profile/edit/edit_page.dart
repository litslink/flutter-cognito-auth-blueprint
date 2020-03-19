import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
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
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  String _picUrl;
  EditBloc _editBloc;

  @override
  Widget build(BuildContext context) {
    final userRepository = Provider.of<UserRepository>(context);
    _editBloc = EditBloc(userRepository)..add(LoadUser());

    return Scaffold(
        body: BlocListener<EditBloc, EditState>(
      bloc: _editBloc,
      listener: (context, state) {
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
            _picUrl = state.image.path;
          }
          return _buildScreen(state);
        },
      ),
    ));
  }

  Widget _buildScreen(EditState state) {
    if (state is UserLoaded) {
      _firstNameController.text = state.user.name;
      _lastNameController.text = state.user.familyName;
    }
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
                    backgroundImage: _buildAvatar(state),
                    child: state is! PicturePicked
                        ? Icon(Icons.camera_alt, color: Colors.white)
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
                  Container(
                    child: state is EditLoading ? LoadingIndicator() : null,
                  ),
                ],
              ),
            )
          ],
        )));
  }

  void _onUpdateButtonPressed() {
    _editBloc.add(
      UpdateButtonPressed(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          picUrl: _picUrl),
    );
  }

  void _onPicPressed(ImageSource imageSource) {
    Navigator.pop(context);
    _editBloc.add(
      PicPressed(imageSource: imageSource),
    );
  }

  ImageProvider _buildAvatar(EditState state) {
    if (state is PicturePicked) {
      return FileImage(state.image);
    } else if (state is UserLoaded) {
      return NetworkImage(state.user.picture);
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
