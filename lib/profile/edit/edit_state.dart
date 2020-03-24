import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../data/model/user.dart';

abstract class EditState extends Equatable {
  const EditState();

  @override
  List<Object> get props => null;
}

class UserLoaded extends EditState {
  final User user;

  const UserLoaded({@required this.user});

  @override
  List<Object> get props => [user];
}

class EditRequired extends EditState {
  final bool isFirstNameValid;
  final bool isLastNameValid;

  const EditRequired({this.isFirstNameValid, this.isLastNameValid});
}

class LoadingUser extends EditState {}

class FieldChanged extends EditState {}

class Edited extends EditState {}

class PicturePicked extends EditState {
  final File image;

  const PicturePicked({@required this.image});

  @override
  List<File> get props => [image];
}

class EditFailure extends EditState {
  final String error;

  const EditFailure({this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'EditingFailure { error: $error }';
}

class EditLoading extends EditState {}
