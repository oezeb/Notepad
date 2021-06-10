import 'package:flutter/cupertino.dart';

import '../main.dart';
import '../models/note.dart';

class FavoritesVM extends ChangeNotifier {
  Map<String, Note> noteMap;

  reload() async {
    noteMap = await db.query();
    notifyListeners();
  }

  switchFav(String id) async {
    noteMap[id].favorite = !noteMap[id].favorite;
    update(id);
  }

  Future<List<Note>> query() async {
    if (noteMap == null) noteMap = await db.query();
    return noteMap.values.where((note) => noteMap[note.id].favorite).toList();
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
