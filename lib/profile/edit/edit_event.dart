import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

abstract class EditEvent extends Equatable {
  const EditEvent();

  @override
  List<Object> get props => null;
}

class LoadUser extends EditEvent {
  final String firstName;
  final String lastName;
  final String picUrl;

  const LoadUser({this.firstName, this.lastName, this.picUrl});

  @override
  List<Object> get props => [firstName, lastName];

  @override
  String toString() => 'loading user';
}

class UpdateButtonPressed extends EditEvent {
  final String firstName;
  final String lastName;
  final String picUrl;

  const UpdateButtonPressed({this.firstName, this.lastName, this.picUrl});

  @override
  List<Object> get props => [firstName, lastName];

  @override
  String toString() => 'update button pressed';
}

class PicPressed extends EditEvent {
  final ImageSource imageSource;

  const PicPressed({@required this.imageSource});

  @override
  List<ImageSource> get props => [imageSource];

  @override
  String toString() => 'pic pressed';
}

class SignOutUser extends EditEvent {}