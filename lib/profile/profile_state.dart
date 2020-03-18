import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../data/model/user.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => null;
}

class UserLoaded extends ProfileState {
  final User user;

  const UserLoaded({@required this.user});

  @override
  List<Object> get props => [user];
}

class LoadingUser extends ProfileState {}

class UserLoadingFailure extends ProfileState {
  final String error;

  const UserLoadingFailure({this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'UserEditingFailure { error: $error }';
}

class SignedOut extends ProfileState {}
