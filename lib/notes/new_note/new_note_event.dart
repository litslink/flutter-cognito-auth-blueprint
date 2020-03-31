import 'package:equatable/equatable.dart';

abstract class NewNoteEvent extends Equatable {
  @override
  List<Object> get props => null;
}

class AddNote extends NewNoteEvent {}
