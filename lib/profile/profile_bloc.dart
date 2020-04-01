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
      final user = await _userRepository.getUserInfo();
      if (user != null) {
        yield UserLoaded(user: user);
      }
    }
    if (event is SetNotificationStatus) {
      final attrs = {
        'custom:notification': event.isOn ? "on" : "off",
      };
      await _userRepository.updateUserInfo(userAttributes: attrs);
    }
    if (event is SignOutUser) {
      await _authenticationRepository.signOut();
      yield SignedOut();
    }
  }
}
