import 'package:notepad/models/note.dart';

import '../main.dart';

class SearchVM {
  List<Note> get query => allNotes.values.toList();

  update(Note note) async {
    allNotes[note.id] = note;
    await db.update(note);
  }

  delete(String id) async {
    allNotes.remove(id);
    await db.delete(id);
  }
}
