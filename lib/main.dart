import 'package:flutter/material.dart';

import 'data_base/notes_database.dart';
import 'models/note.dart';
import 'views/homepage.dart';

NotesDatabase db;
Map<String, Note> allNotes;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  db = NotesDatabase(fileName: 'notes.db');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notepad',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            allNotes = snapshot.data;
            return HomePage();
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
        future: db.query(),
      ),
    );
  }
}
