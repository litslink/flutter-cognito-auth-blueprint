import 'package:equatable/equatable.dart';

abstract class NewNoteState extends Equatable {
  const NewNoteState();

  @override
  List<Object> get props => null;
}

class Loading extends NewNoteState {}

class EditNote extends NewNoteState {}

class Success extends NewNoteState {}

class AddingFailure extends NewNoteState {
  final String error;

  const AddingFailure({this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'AddingFailure { error: $error }';
}
