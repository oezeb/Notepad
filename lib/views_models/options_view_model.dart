import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/note.dart';
import '../main.dart';

class OptionsVM extends ChangeNotifier {
  Set<String> selected; // IDs
  Map<String, Note> noteMap;

  OptionsVM({List<Note> notes, List<String> selected})
      : this.noteMap = {},
        this.selected = selected.toSet() {
    notes.forEach(
      (note) {
        this.noteMap[note.id] = note;
      },
    );
  }

  switchSelected(String id) {
    if (isSelected(id))
      selected.remove(id);
    else
      selected.add(id);
    notifyListeners();
  }

  bool isSelected(String id) => selected.contains(id);

  bool isfav() {
    for (var id in selected) {
      if (!noteMap[id].favorite) return false;
    }
    return true;
  }

  Future<void> switchFav() async {
    bool fav = isfav();
    selected.forEach((id) async {
      noteMap[id].favorite = !fav;
      await update(id);
    });
    notifyListeners();
  }

  List<Note> get notes => noteMap.values.toList();

  update(String id) async {
    await db.update(noteMap[id]);
    notifyListeners();
  }

  Future<void> delete() async {
    selected.forEach((id) async {
      noteMap.remove(id);
      await db.delete(id);
    });
    selected = {};
    notifyListeners();
  }
}
