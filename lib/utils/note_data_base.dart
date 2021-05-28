import 'dart:convert';

import '../models/notemap.dart';
import '../utils/filetream.dart';
import '../models/note.dart';

/*
 * Used the file Stream to create a data base with basic methods
 */

class NoteDataBase {
  final FileStream _fstream;
  var _nextId;

  NoteDataBase({String fileName})
      : this._fstream = FileStream(fileName: fileName),
        _nextId = 0;

  get noteMap async {
    String contents = await _fstream.fileContent;
    return NoteMap.fromString(contents);
  }

  Future<bool> containsKey(String id) async {
    final map = await noteMap;
    return map.data.containsKey(id);
  }

  Future<String> get nextId async {
    while (true) {
      final bool exist = await containsKey(_nextId.toString());
      if (!exist && _nextId != 0) break;
      _nextId++;
    }
    return _nextId.toString();
  }

  add(String key, Note note) async {
    final map = await noteMap;
    map.data[key] = note;
    _fstream.write(jsonEncode(map.toJson()));
  }

  remove(String key, Note note) async {
    final map = await noteMap;
    map.data.remove(key);
    _fstream.write(jsonEncode(map.toJson()));
  }

  Stream<NoteMap> snapshots() async* {
    final stream = _fstream.snapshots();
    await for (var str in stream) yield NoteMap.fromString(str);
  }
}
