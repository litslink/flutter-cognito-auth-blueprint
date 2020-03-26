import 'package:amazon_s3_cognito/amazon_s3_cognito.dart';
import 'package:bloc/bloc.dart';
import '../../data/repository/user_repository.dart';
import '../../validation/validation_bloc.dart';
import '../../validation/validation_state.dart';
import '../../validation/validator.dart';
import 'edit_event.dart';
import 'edit_state.dart';

class EditBloc extends Bloc<EditEvent, EditState> {
  final UserRepository _userRepository;

  EditBloc(this._userRepository);

  final _firstName = ValidationBloc(NameValidator());
  final _lastName = ValidationBloc(NameValidator());

  @override
  EditState get initialState => LoadingUser();

  @override
  Stream<EditState> mapEventToState(EditEvent event) async* {
    if (event is LoadUser) {
      final user = await _userRepository.getUserInfo();
      if (user != null) {
        yield UserLoaded(user: user);
        yield EditRequired(isFirstNameValid: true, isLastNameValid: true);
      }
    }
    if (event is PicPressed) {
      final image = await _userRepository.getImage(source: event.imageSource);
      if (image != null) {
        yield PicturePicked(image: image);
      }
    }
    if (event is UpdateButtonPressed) {
      yield EditLoading();
      try {
        if (_firstName.state is FieldValid && _lastName.state is FieldValid) {
          String imageUrl;
          if (event.picUrl != null) {
            imageUrl = await AmazonS3Cognito.uploadImage(
                event.picUrl,
                "flutter-cognito-blueprint-us-east-1",
                "eu-west-2:89d2b2b8-2787-4a42-b1b4-f4453bbaa376");
          }
          final attrs = {
            'name': (_firstName.state as FieldValid).text,
            'family_name': (_lastName.state as FieldValid).text,
            'picture': imageUrl == null ? "" : imageUrl
          };
          await _userRepository.updateUserInfo(userAttributes: attrs);
          yield Edited();
          yield EditRequired(isFirstNameValid: true, isLastNameValid: true);
        }
        yield EditRequired(
            isFirstNameValid: _firstName.state is FieldValid,
            isLastNameValid: _lastName.state is FieldValid);
      } on Exception catch (error) {
        yield EditFailure(error: error.toString());
        yield EditRequired(isFirstNameValid: true, isLastNameValid: true);
      }
    }
    if (event is FirstNameChanged) {
      yield FieldChanged();
      _firstName.add(event.firstName);
      yield EditRequired(isFirstNameValid: true, isLastNameValid: true);
    }
    if (event is LastNameChanged) {
      yield FieldChanged();
      _lastName.add(event.lastName);
      yield EditRequired(isFirstNameValid: true, isLastNameValid: true);
    }
  }

  @override
  Future<Function> close() {
    super.close();
    _firstName.close();
    _lastName.close();
  }
}
