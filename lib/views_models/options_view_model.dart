import 'package:flutter/material.dart';

import '../models/note.dart';
import '../main.dart';

class OptionsVM {
  Set<String> _selected; // IDs
  Map<String, Note> _noteMap;

  OptionsVM({@required List<Note> notes, @required List<String> selected})
      : _noteMap = {},
        _selected = selected.toSet() {
    notes.forEach(
      (note) {
        _noteMap[note.id] = note;
      },
    );
  }

  bool get favorite {
    for (var id in _selected) {
      if (!_noteMap[id].favorite) return false;
    }
    return true;
  }

  bool isSelected(String id) => _selected.contains(id);

  switchSelected(String id) {
    if (isSelected(id)) {
      _selected.remove(id);
    } else {
      _selected.add(id);
    }
  }

  switchFavorite([String id]) async {
    if (id == null) {
      final bool res = favorite;
      _selected.forEach((id) async {
        _noteMap[id].favorite = !res;
        await update(id);
      });
    } else {
      _noteMap[id].favorite = !_noteMap[id].favorite;
      await update(id);
    }
  }

  List<Note> get query => _noteMap.values.toList();

  update(String id) async {
    allNotes[id] = _noteMap[id];
    await db.update(_noteMap[id]);
  }

  Future<void> delete() async {
    _selected.forEach((id) async {
      _noteMap.remove(id);
      allNotes.remove(id);
      await db.delete(id);
    });
    _selected = {};
  }
}
