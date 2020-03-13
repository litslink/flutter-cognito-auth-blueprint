import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cognito_plugin/flutter_cognito_plugin.dart';
import 'package:image_picker/image_picker.dart';

class UserRepository {
  Future<Map<String, String>> getUserInfo() async {
    return await Cognito.getUserAttributes();
  }

  Future<List<UserCodeDeliveryDetails>> updateUserInfo(
      {@required Map<String, String> userAttributes}) async {
    return await Cognito.updateUserAttributes(userAttributes);
  }

  Future<File> getImage({@required ImageSource source}) async {
    return await ImagePicker.pickImage(source: source);
  }
}
