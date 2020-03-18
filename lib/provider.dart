
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'data/repository/authentication_repository.dart';
import 'data/repository/user_repository.dart';

final List<SingleChildWidget> providers = [
  Provider<AuthenticationRepository>(
      create: (context) => AuthenticationRepository(GoogleSignIn(
        scopes: <String>[
          'email',],
      ))),
  Provider<UserRepository>(create: (context) => UserRepository()),
];
