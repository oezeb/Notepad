import 'package:flutter/cupertino.dart';

import '../main.dart';
import '../models/note.dart';

class HomeVM extends ChangeNotifier {
  insert(Note note) async {
    allNotes[note.id] = note;
    await db.insert(note);
  }

  List<Note> get query => allNotes.values.toList();

  update(Note note) async {
    allNotes[note.id] = note;
    await db.update(allNotes[note.id]);
  }

  deleteNote(String id) async {
    allNotes.remove(id);
    await db.delete(id);
  }
}
