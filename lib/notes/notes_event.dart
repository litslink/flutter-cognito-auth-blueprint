import 'package:equatable/equatable.dart';

abstract class NotesEvent extends Equatable {
  @override
  List<Object> get props => null;
}

class LoadNotes extends NotesEvent {}

class DeleteNote extends NotesEvent {}
