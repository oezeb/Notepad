import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../models/note.dart';

class NotesDatabase {
  final Uuid _uuid = Uuid();
  final _database;

  NotesDatabase({String fileName})
      : _database = openDatabase(
          fileName,
          onCreate: (db, version) {
            return db.execute(
              'CREATE TABLE notes (id TEXT PRIMARY KEY, title TEXT, text TEXT, favorite BOOL, editDate DATETIME)',
            );
          },
          version: 1,
        );

  Future<int> insert(Note note) async {
    // getting new random id
    if (note.id == null) note.id = _uuid.v4();
    final Database db = await _database;
    return db.insert('notes', note.toMap());
  }

  Future<int> delete(String id) async {
    final Database db = await _database;
    return db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(Note note) async {
    final Database db = await _database;
    return db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<Map<String, Note>> query() async {
    final Database db = await _database;
    List<Map<String, dynamic>> list = await db.query('notes');
    final Map<String, Note> notes = {};
    for (var map in list) {
      Note note = Note.fromMap(map);
      notes[note.id] = note;
    }
    return notes;
  }
}
