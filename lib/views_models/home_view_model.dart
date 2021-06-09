import 'package:flutter/cupertino.dart';

import '../main.dart';
import '../models/note.dart';
import '../utils/constants.dart';

class HomeVM extends ChangeNotifier {
  Map<String, Note> noteMap;

  reload() async {
    noteMap = await db.query();
    notifyListeners();
  }

  switchFav(String id) async {
    noteMap[id].favorite = !noteMap[id].favorite;
    update(id);
  }

  Future<List<Note>> notesToDisplay(Pages page) async {
    if (noteMap == null) noteMap = await db.query();
    switch (page) {
      case Pages.ALL_NOTES:
        return noteMap.values.toList();
      case Pages.FAVORITES:
        return noteMap.values
            .where((note) => noteMap[note.id].favorite)
            .toList();
    }
    return null;
  }

  update(String id) async {
    await db.update(noteMap[id]);
    reload();
  }

  deleteNote(String key) async {
    await db.delete(key);
    reload();
  }
}
