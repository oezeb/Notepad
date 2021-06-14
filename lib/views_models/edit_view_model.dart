import 'package:flutter/cupertino.dart';

import '../utils/date.dart';
import '../models/note.dart';
import '../main.dart';

class EditVM extends ChangeNotifier {
  final TextEditingController titleCtrl;
  final TextEditingController textCtrl;
  bool favorite;
  bool _updated;
  DateTime _editDate;
  String _id;

  EditVM(Note note)
      : _id = note.id,
        titleCtrl = TextEditingController(text: note.title),
        textCtrl = TextEditingController(text: note.text),
        favorite = note.favorite,
        _editDate = note.editDate,
        _updated = false;

  String get editDate => Date.getString(_editDate);

  Note get note => isValid
      ? Note(
          id: _id,
          title: title,
          text: text,
          favorite: favorite,
          editDate: _editDate,
        )
      : null;

  String get title => titleCtrl.text;

  String get text => textCtrl.text;

  bool get isValid => title != '' || text != '';

  set title(String title) {
    titleCtrl.text = title;
    update();
  }

  set text(String text) {
    textCtrl.text = text;
    update();
  }

  update() async {
    // delete from database if empty note
    if (!isValid) {
      await delete();
      return;
    }
    // update data
    if (_updated == false) {
      _editDate = DateTime.now();
      _updated = true;
    }
    int num = await db.update(note);
    // num == 0 means note doesn't exist in the database
    if (num == 0) {
      _id = await db.insert(note);
    }
  }

  delete() async {
    await db.delete(_id);
  }
}
