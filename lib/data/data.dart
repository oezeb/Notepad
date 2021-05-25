import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:notepad/models/note.dart';

Data dataBase = Data("notes.txt");

class Data {
  String _fileName;
  String _fileContent;
  Map<String, Note> _allNotes;
  var _nextId;

  Data(String fileName)
      : _fileName = fileName,
        _fileContent = "",
        _allNotes = {},
        _nextId = 0;

  get _localPath async {
    final appDocDir = await getApplicationDocumentsDirectory();
    return appDocDir.path;
  }

  get _localFile async {
    final path = await _localPath;
    final file = File('$path/' + _fileName);
    final exist = await file.exists();
    if (!exist) await file.create();
    return file;
  }

  get allNotes => _allNotes.values;

  get nextId {
    while (_allNotes.containsKey(_nextId.toString()) || _nextId == 0) _nextId++;
    return _nextId.toString();
  }

  deleteNote(String noteId) async {
    _allNotes.remove(noteId);
    return saveAll(_allNotes);
  }

  saveNote(Note note) async {
    _allNotes[note.noteId] = note;
    return saveAll(_allNotes);
  }

  saveAll(Map<String, Note> all) async {
    final file = await _localFile;
    await file.open(mode: FileMode.write);
    return file.writeAsString(getString(all));
  }

  getString(Map<String, Note> all) {
    String str = "";
    all.forEach((key, value) {
      str += value.toString();
    });
    return str;
  }

  static String mark(String text, String keyword) {
    final bunks = text.split(RegExp(keyword));
    String ans;
    int i = 0;
    if (text.indexOf(keyword) == 0)
      ans = "**" + keyword;
    else
      ans = bunks[i++] + "**" + keyword;
    while (i < bunks.length) {
      ans += "**" + bunks[i++];
    }
    return ans;
  }

  Map<String, Note> search(String keyword) {
    if (keyword == "") {
      return {};
    } else {
      Map<String, Note> ans = {};
      _allNotes.forEach((key, value) {
        ans[key] = Note.copy(_allNotes[key]);
        ans[key].title = mark(ans[key].title, keyword);
        ans[key].text = mark(ans[key].text, keyword);
      });
      return ans;
    }
  }

  Stream<Map<String, Map<String, Note>>> snapshots() async* {
    final file = await _localFile;
    while (true) {
      final contents = await file.readAsString();
      if (contents == "" || contents != _fileContent) {
        _fileContent = contents;
        _allNotes = Note.parseNotes(contents);
        Map<String, Note> fav = {};
        _allNotes.forEach((key, value) {
          if (value.favorite) fav.addAll({key: value});
        });
        yield {
          "allNotes": _allNotes,
          "favorites": fav,
        };
      }
    }
  }
}
