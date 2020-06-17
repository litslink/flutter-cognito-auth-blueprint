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
    switch (event.runtimeType) {
      case PicPressed:
        final imageSource = (event as PicPressed).imageSource;
        final image = await _userRepository.getImage(source: imageSource);
        if (image != null) {
          yield PicturePicked(image: image);
        }
        break;
      case UpdateButtonPressed:
        yield Loading();
        try {
          if (_firstName.state is FieldValid && _lastName.state is FieldValid) {
            String imageUrl;
            final picUrl = (event as UpdateButtonPressed).picUrl;
            if (picUrl.isNotEmpty) {
              imageUrl = await _userRepository.uploadImage(picUrl: picUrl);
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
        break;
      case FirstNameChanged:
        final firstName = (event as FirstNameChanged).firstName;
        _firstName.add(firstName);
        yield EditRequired(isFirstNameValid: true, isLastNameValid: true);
        break;
      case LastNameChanged:
        final lastName = (event as LastNameChanged).lastName;
        _lastName.add(lastName);
        yield EditRequired(isFirstNameValid: true, isLastNameValid: true);
        break;
    }
  }

  @override
  Future<void> close() {
    _firstName.close();
    _lastName.close();
    return super.close();
  }
}
