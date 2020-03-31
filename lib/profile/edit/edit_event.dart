import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

abstract class EditEvent extends Equatable {
  const EditEvent();

  @override
  List<Object> get props => null;
}

class UpdateButtonPressed extends EditEvent {
  final String picUrl;

  const UpdateButtonPressed({this.picUrl});

  @override
  List<Object> get props => null;

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

class FirstNameChanged extends EditEvent {
  final String firstName;

  FirstNameChanged(this.firstName);

  @override
  List<Object> get props => null;

  @override
  String toString() => 'first name changed';
}

class LastNameChanged extends EditEvent {
  final String lastName;

  LastNameChanged(this.lastName);

  @override
  List<Object> get props => null;

  @override
  String toString() => 'last name changed';
}
