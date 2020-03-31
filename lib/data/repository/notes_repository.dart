import 'package:amazon_s3_cognito/amazon_s3_cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/data/model/note.dart';

class NotesRepository {
  Future<void> add(String userId, Note note) async {}

  Future<void> delete(String userId, Note note) async {}

  Stream<List<Note>> get(String userId) async* {}
}
