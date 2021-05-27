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

  get nextId {
    while (_allNotes.containsKey(_nextId.toString()) || _nextId == 0) _nextId++;
    return _nextId.toString();
  }

  refresh() async {
    final file = await _localFile;
    _fileContent = await file.readAsString();
    _allNotes = Note.parseNotes(_fileContent);
  }

  deleteNote(String noteId) async {
    _allNotes.remove(noteId);
    return save();
  }

  saveNote(Note note) {
    _allNotes[note.noteId] = note;
    return save();
  }

  save() async {
    final contents = getString(_allNotes);
    File file = await _localFile;
    file = await file.writeAsString(contents);
    final newContents = await file.readAsString();
    return contents == newContents;
  }

  String getString(Map<String, Note> all) {
    String str = "";
    all.forEach((key, value) {
      str += value.toString();
    });
    return str;
  }

  Stream<String> fstream() async* {
    final file = await _localFile;
    while (true) {
      final contents = await file.readAsString();
      if (contents == "" || contents != _fileContent) {
        _fileContent = contents;
        yield _fileContent;
      }
    }
  }

  Stream<Map<String, Note>> allNotes() async* {
    final stream = fstream();
    await for (var str in stream) {
      _allNotes = Note.parseNotes(str);
      yield _allNotes;
    }
  }

  Stream<Map<String, Map<String, Note>>> snapshots() async* {
    final stream = allNotes();
    await for (var notes in stream) {
      Map<String, Note> fav = {};
      notes.forEach((key, value) {
        if (value.favorite) fav[key] = value;
      });
      yield {
        "allNotes": _allNotes,
        "favorites": fav,
      };
    }
  }
}
