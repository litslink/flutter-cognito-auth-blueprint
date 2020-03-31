import 'package:equatable/equatable.dart';

abstract class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object> get props => null;
}

class Loading extends NotesState {}

class NotesList extends NotesState {}

class Failure extends NotesState {
  final String error;

  const Failure({this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'NotesFailure { error: $error }';
}
