import 'package:equatable/equatable.dart';

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

class SetNotificationStatus extends ProfileEvent {
  final bool isOn;

  const SetNotificationStatus({this.isOn});

  @override
  List<Object> get props => [isOn];

  @override
  String toString() => 'setting notification status';
}

class SignOutUser extends ProfileEvent {}
