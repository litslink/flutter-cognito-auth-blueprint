import 'package:bloc/bloc.dart';
import 'package:flutterapp/data/model/note.dart';
import '../data/repository/notes_repository.dart';
import 'notes_event.dart';
import 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesRepository _notesRepository;

  NotesBloc(this._notesRepository);

  @override
  NotesState get initialState => Loading();

  @override
  Stream<NotesState> mapEventToState(NotesEvent event) async* {
    if (event is LoadNotes) {
      yield Loading();
      try {
        final notes = await _notesRepository.get("userId");
        yield NotesList();
      } on Exception catch (error) {
        yield Failure(error: error.toString());
        yield NotesList();
      }
    }
    if (event is DeleteNote) {
      yield Loading();
      try {
        await _notesRepository.delete(null, null);
        yield NotesList();
      } on Exception catch (error) {
        yield Failure(error: error.toString());
        yield NotesList();
      }
    }
  }
}
