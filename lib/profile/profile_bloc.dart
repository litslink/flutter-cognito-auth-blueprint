import 'package:bloc/bloc.dart';
import '../data/repository/user_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;

  ProfileBloc(this._userRepository);

  @override
  ProfileState get initialState => Unedited();

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is UpdateButtonPressed) {
      yield EditingLoading();
      await _userRepository.updateUserInfo(userAttributes: null);
    }
  }
}
