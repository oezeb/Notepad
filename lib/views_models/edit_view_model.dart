import '../models/note.dart';
import '../main.dart';

class EditVM {
  String key;
  Note note;

  EditVM({this.key, this.note});

  saveNote() async {
    if (note != null && !note.isEmpty()) {
      note.editDate = DateTime.now();
      await noteDataBase.add(key, note);
    }
    return true;
  }

  delete() async {
    await noteDataBase.remove(key, note);
  }
}
