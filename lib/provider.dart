import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'data/repository/authentication_repository.dart';

final List<SingleChildWidget> providers = [
  Provider<AuthenticationRepository>(
      create: (context) => AuthenticationRepository())
];
