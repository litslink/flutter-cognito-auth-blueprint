import 'package:bloc/bloc.dart';
import '../data/repository/authentication_repository.dart';

import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final AuthenticationRepository _authenticationRepository;

  SplashBloc(this._authenticationRepository);

  @override
  SplashState get initialState => AppStarted();

  @override
  Stream<SplashState> mapEventToState(SplashEvent event) async* {
    if (event is CheckAuthentication) {
      await _authenticationRepository.initCognito();
      var status = await _authenticationRepository.getUserStatus();
      if (status.toString() == "UserState.SIGNED_IN") {
        yield Authenticated();
      } else {
        yield AuthenticationRequired();
      }
    }
  }
}
