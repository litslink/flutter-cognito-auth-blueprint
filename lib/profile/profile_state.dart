import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object> get props => null;
}

class Unedited extends ProfileState {}

class Edited extends ProfileState {}

class EditingFailure extends ProfileState {}

class EditingLoading extends ProfileState {}
