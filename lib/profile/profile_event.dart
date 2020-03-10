import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => null;
}

class FirstNameChanged extends ProfileEvent {}

class LastNameChanged extends ProfileEvent {}

class PicChanged extends ProfileEvent {}

class UpdateButtonPressed extends ProfileEvent {
  final String firstName;
  final String lastName;

  const UpdateButtonPressed({
    @required this.firstName,
    @required this.lastName,
  });

  @override
  List<Object> get props => [firstName, lastName];

  @override
  String toString() => 'update button pressed';
}

class PicPressed extends ProfileEvent {
  @override
  List<Object> get props => null;

  @override
  String toString() => 'pic pressed';
}
