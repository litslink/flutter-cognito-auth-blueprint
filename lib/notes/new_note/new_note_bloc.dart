import 'package:bloc/bloc.dart';
import '../../data/repository/notes_repository.dart';
import 'new_note_event.dart';
import 'new_note_state.dart';

class NewNoteBloc extends Bloc<NewNoteEvent, NewNoteState> {
  final NotesRepository _notesRepository;

  NewNoteBloc(this._notesRepository);

  @override
  NewNoteState get initialState => EditNote();

  @override
  Stream<NewNoteState> mapEventToState(NewNoteEvent event) async* {
    if (event is AddNote) {
      yield Loading();
      try {
        await _notesRepository.add("userId", null);
        yield Success();
      } on Exception catch (error) {
        yield AddingFailure(error: error.toString());
        yield EditNote();
      }
    }
  }
}
