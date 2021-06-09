import 'package:flutter/material.dart';
import 'package:notepad/data_base/notes_database.dart';
import 'package:notepad/views_models/home_view_model.dart';
import 'package:provider/provider.dart';

import 'utils/constants.dart';
import 'views/homepage.dart';

NotesDatabase db;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  db = NotesDatabase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.APP_NAME,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ChangeNotifierProvider(
        create: (context) => HomeVM(),
        child: HomePage(title: Constants.APP_NAME),
      ),
    );
  }
}
