import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => null;
}

class LoadUser extends ProfileEvent {
  final String firstName;
  final String lastName;
  final String picUrl;

  const LoadUser({this.firstName, this.lastName, this.picUrl});

  @override
  List<Object> get props => [firstName, lastName];

  @override
  String toString() => 'loading user';
}

class UpdateButtonPressed extends ProfileEvent {
  final String firstName;
  final String lastName;
  final String picUrl;

  const UpdateButtonPressed({this.firstName, this.lastName, this.picUrl});

  @override
  List<Object> get props => [firstName, lastName];

  @override
  String toString() => 'update button pressed';
}

class PicPressed extends ProfileEvent {
  final ImageSource imageSource;

  const PicPressed({@required this.imageSource});

  @override
  List<ImageSource> get props => [imageSource];

  @override
  String toString() => 'pic pressed';
}

class SignOutUser extends ProfileEvent {}
