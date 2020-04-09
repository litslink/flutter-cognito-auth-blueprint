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

  final _firstName = ValidationBloc(NonEmptyValidator());
  final _lastName = ValidationBloc(NonEmptyValidator());

  @override
  EditState get initialState =>
      EditRequired(isFirstNameValid: true, isLastNameValid: true);

  @override
  Stream<EditState> mapEventToState(EditEvent event) async* {
    if (event is PicPressed) {
      final image = await _userRepository.getImage(source: event.imageSource);
      if (image != null) {
        yield PicturePicked(image: image);
      }
    }
    if (event is UpdateButtonPressed) {
      yield Loading();
      try {
        if (_firstName.state is FieldValid && _lastName.state is FieldValid) {
          String imageUrl;
          if (event.picUrl.isNotEmpty) {
            imageUrl = await _userRepository.uploadImage(picUrl: event.picUrl);
          }
          final attrs = {
            'name': (_firstName.state as FieldValid).text,
            'family_name': (_lastName.state as FieldValid).text,
          };
          if (imageUrl != null) {
            attrs["picture"] = imageUrl;
          }
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
      _firstName.add(event.firstName);
      yield EditRequired(isFirstNameValid: true, isLastNameValid: true);
    }
    if (event is LastNameChanged) {
      _lastName.add(event.lastName);
      yield EditRequired(isFirstNameValid: true, isLastNameValid: true);
    }
  }

  @override
  Future<void> close() {
    _firstName.close();
    _lastName.close();
    return super.close();
  }
}
