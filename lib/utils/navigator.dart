import 'package:flutter/material.dart';

import '../models/note.dart';
import '../views/searchpage.dart';
import '../views/editpage.dart';
import '../views/optionspage.dart';
import '../views/favoritespage.dart';
import '../views/homepage.dart';

class AppNavigator {
  static navigateToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  static navigateToFavorites(BuildContext context) {
    navigateToHome(context);
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FavoritesPage()),
    );
  }

  static navigateToEditNote({BuildContext context, Note note}) async {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditPage(note: note)),
    );
  }

  static navigateToOptions({
    BuildContext context,
    List<Note> notes,
    List<String> selected,
  }) async {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OptionsPage(notes: notes, selected: selected),
      ),
    );
  }

  static navigateToSearch(BuildContext context) async {
    await showSearch(
      context: context,
      delegate: SearchPage(context: context),
    );
  }
}
