import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../data/model/note.dart';
import '../data/repository/notes_repository.dart';
import 'notes_bloc.dart';
import 'notes_event.dart';
import 'notes_state.dart';

class NotesPage extends StatelessWidget {
  NotesBloc _notesBloc;
  List<Note> _notes;

  @override
  Widget build(BuildContext context) {
    final notesRepository = Provider.of<NotesRepository>(context);
    _notesBloc = NotesBloc(notesRepository)..add(LoadNotes());
    return Scaffold(
        body: BlocListener<NotesBloc, NotesState>(
      bloc: _notesBloc,
      listener: (context, state) {},
      child: BlocBuilder<NotesBloc, NotesState>(
        bloc: _notesBloc,
        builder: (context, state) => ListView.builder(
            itemCount: _notes.length,
            itemBuilder: (context, index) => _buildNote(_notes[index])),
      ),
    ));
  }

  Widget _buildNote(Note note) {
    return Card(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    note.title,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
                IconButton(
                  onPressed: () => _notesBloc.add(DeleteNote()),
                  icon: Icon(Icons.delete),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  note.text,
                  style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                )),
          )
        ],
      ),
    );
  }
}
