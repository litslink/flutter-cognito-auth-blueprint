import 'package:flutter/material.dart';
import 'package:flutter_cognito_plugin/flutter_cognito_plugin.dart';

class UserRepository {
  Future<Map<String, String>> getUserInfo() async {
    return await Cognito.getUserAttributes();
  }

  Future<void> updateUserInfo(
      {@required Map<String, String> userAttributes}) async {
    await Cognito.updateUserAttributes(userAttributes);
  }
}
