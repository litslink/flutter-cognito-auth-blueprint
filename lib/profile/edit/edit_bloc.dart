import 'package:amazon_s3_cognito/amazon_s3_cognito.dart';
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
      final user = await _userRepository.getUserInfo();
      if (user != null) {
        yield UserLoaded(user: user);
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
      final imageUrl = await AmazonS3Cognito.uploadImage(
          event.picUrl,
          "flutter-cognito-blueprint-bucket",
          "eu-west-2:89d2b2b8-2787-4a42-b1b4-f4453bbaa376");
      final attrs = {
        'name': event.firstName,
        'family_name': event.lastName,
        'picture': imageUrl
      };
      await _userRepository.updateUserInfo(userAttributes: attrs);
      yield Edited();
    }
  }
}
