import 'package:notepad/models/note.dart';

var nextId = 0;

String getNextId() {
  while (allNotes.containsKey(nextId.toString()) || nextId == 0) nextId++;
  return nextId.toString();
}

Map<String, Note> allNotes = {};

Map<String, Note> favNotes() {
  Map<String, Note> map = {};
  allNotes.forEach((key, value) {
    if (value.favorite) map.addAll({key: value});
  });
  return map;
}

void deleteNote(String noteId) {
  allNotes.remove(noteId);
}

Map<String, Map<String, Note>> getNotesMap() {
  return {
    "allNotes": allNotes,
    "favorites": favNotes(),
  };
}
