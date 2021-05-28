import '../main.dart';
import '../models/note.dart';
import '../utils/constants.dart';

class HomeVM {
  Map<String, Note> noteMap = {};

  switchFav(String key) async {
    if (noteMap.containsKey(key)) {
      noteMap[key].favorite = !noteMap[key].favorite;
      return await noteDataBase.add(key, noteMap[key]);
    }
  }

  Future<String> nextKey() async {
    return noteDataBase.nextId;
  }

  getNote([String key]) {
    if (key == null)
      return Note();
    else
      return noteExist(key) ? noteMap[key] : Note();
  }

  noteExist(String key) => noteMap.containsKey(key);

  saveNote(String key) async {
    if (key == null) key = await noteDataBase.nextId;
    noteDataBase.add(key, noteMap[key]);
  }

  deleteNote(String key) async {
    if (key != null && noteExist(key))
      await noteDataBase.remove(key, noteMap[key]);
  }

  notesToDisplay(Pages page) {
    switch (page) {
      case Pages.ALL_NOTES:
        return noteMap.keys.toList();
      case Pages.SEARCH:
        return noteMap;
      case Pages.FAVORITES:
        return noteMap.keys.where((key) => noteMap[key].favorite).toList();
    }
  }
}
