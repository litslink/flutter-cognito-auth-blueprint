import 'dart:io';
import 'package:amazon_s3_cognito/amazon_s3_cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cognito_plugin/flutter_cognito_plugin.dart';
import 'package:image_picker/image_picker.dart';
import '../model/user.dart';

class UserRepository {
  Future<User> getUserInfo() async {
    final attrs = await Cognito.getUserAttributes();
    return User.fromMap(attrs);
  }

  Future<List<UserCodeDeliveryDetails>> updateUserInfo(
      {@required Map<String, String> userAttributes}) async {
    return await Cognito.updateUserAttributes(userAttributes);
  }

  Future<File> getImage({@required ImageSource source}) async {
    return await ImagePicker.pickImage(source: source);
  }

  Future<String> uploadImage({@required String picUrl}) async {
    return await AmazonS3Cognito.uploadImage(
        picUrl,
        "flutter-cognito-blueprint-us-east-1",
        "eu-west-2:89d2b2b8-2787-4a42-b1b4-f4453bbaa376");
  }
}
