import 'package:flutter/cupertino.dart';
import 'package:notepad/utils/date.dart';

import '../models/note.dart';
import '../main.dart';

class EditVM extends ChangeNotifier {
  Note _note;
  bool _saved;

  EditVM(Note note)
      : _note = note,
        _saved = note != null && note.id != null;

  bool isFavorite() => _note.favorite;

  String get editDate {
    return Date.getString(_note.editDate);
  }

  get title => _note.title;

  get text => _note.text;

  switchFav() async {
    _note.favorite = !_note.favorite;
    await db.update(_note);
    notifyListeners();
  }

  setTitle(String title) async {
    _note.title = title;
    await update();
  }

  setText(String text) async {
    _note.text = text;
    await update();
  }

  update() async {
    if (_saved) {
      await db.update(_note);
    } else {
      await db.insert(_note);
      _saved = true;
    }
  }

  delete() async {
    await db.delete(_note.id);
  }
}
