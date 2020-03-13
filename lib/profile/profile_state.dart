import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => null;
}

class UserLoaded extends ProfileState {}

class LoadingUser extends ProfileState {}

class Edited extends ProfileState {}

class PicturePicked extends ProfileState {
  final File image;

  const PicturePicked({@required this.image});

  @override
  List<File> get props => [image];
}

class EditingFailure extends ProfileState {
  final String error;

  const EditingFailure({this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'EditingFailure { error: $error }';
}

class EditingLoading extends ProfileState {}

class SignedOut extends ProfileState {}
