import 'package:flutter/cupertino.dart';

import '../utils/date.dart';
import '../models/note.dart';
import '../main.dart';

class EditVM extends ChangeNotifier {
  Note _note;
  bool updated;

  EditVM(Note note)
      : _note = note,
        updated = false;

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
    // delete from database if empty note
    if (_note.title == '' && _note.text == '') {
      await db.delete(_note.id);
      return;
    }
    // update data
    if (updated == false) {
      _note.editDate = DateTime.now();
      updated = true;
    }
    int num = await db.update(_note);
    // num == 0 means note doesn't exist in the database
    if (num == 0) {
      await db.insert(_note);
    }
  }

  delete() async {
    await db.delete(_note.id);
  }
}
