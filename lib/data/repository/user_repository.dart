import 'package:flutter/material.dart';
import 'package:flutter_cognito_plugin/flutter_cognito_plugin.dart';

class UserRepository {
  Future<Map<String, String>> getUserInfo() async {
    return await Cognito.getUserAttributes();
  }

  Future<List<UserCodeDeliveryDetails>> updateUserInfo(
      {@required Map<String, String> userAttributes}) async {
    var res = await Cognito.updateUserAttributes(userAttributes);
    return res;
  }
}
