import 'package:bloc/bloc.dart';
import '../data/repository/authentication_repository.dart';
import '../data/repository/user_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;
  final AuthenticationRepository _authenticationRepository;

  ProfileBloc(this._userRepository, this._authenticationRepository);

  @override
  ProfileState get initialState => LoadingUser();

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
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
      yield EditingLoading();
      var attrs = {
        'name': event.firstName,
        'family name': event.lastName,
        'picture': event.picUrl
      };
      await _userRepository.updateUserInfo(userAttributes: attrs);
    }

    if (event is SignOutUser) {
      await _authenticationRepository.signOut();
      yield SignedOut();
    }
  }
}
