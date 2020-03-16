import 'package:bloc/bloc.dart';
import '../../data/repository/user_repository.dart';
import 'edit_event.dart';
import 'edit_state.dart';

class EditBloc extends Bloc<EditEvent, EditState> {
  final UserRepository _userRepository;

  EditBloc(this._userRepository);

  @override
  EditState get initialState => LoadingUser();

  @override
  Stream<EditState> mapEventToState(EditEvent event) async* {
    if (event is LoadUser) {
      var attrs = await _userRepository.getUserInfo();
      if (attrs != null) {
        yield UserLoaded();
      }
    }
    if (event is PicPressed) {
      var image = await _userRepository.getImage(source: event.imageSource);
      if (image != null) {
        yield PicturePicked(image: image);
      }
    }
    if (event is UpdateButtonPressed) {
      yield EditLoading();
      var attrs = {
        'name': event.firstName,
        'family_name': event.lastName,
        'picture': event.picUrl
      };
      await _userRepository.updateUserInfo(userAttributes: attrs);
    }
  }
}
