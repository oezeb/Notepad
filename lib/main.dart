import 'package:flutter/material.dart';

import 'utils/constants.dart';
import 'utils/note_data_base.dart';
import 'views/homepage.dart';

NoteDataBase noteDataBase;
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    noteDataBase = NoteDataBase(fileName: Constants.FILE_NAME);
    return MaterialApp(
      title: Constants.APP_NAME,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(title: Constants.APP_NAME),
    );
  }
}
