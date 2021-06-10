import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data_base/notes_database.dart';
import 'views/homepage.dart';
import 'views/favoritespage.dart';
import 'views_models/home_view_model.dart';
import 'views_models/favorites_view_model.dart';

NotesDatabase db;

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
      initialRoute: '/',
      routes: {
        '/': (context) => ChangeNotifierProvider(
              create: (context) => HomeVM(),
              child: HomePage(),
            ),
        '/favorites': (context) => ChangeNotifierProvider(
              create: (context) => FavoritesVM(),
              child: FavoritesPage(),
            ),
      },
    );
  }
}
