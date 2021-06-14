import 'package:flutter/material.dart';

import '../widgets.dart/note_widget.dart';
import '../utils/navigator.dart';
import '../widgets.dart/appdrawer.dart';
import '../models/note.dart';
import '../views_models/favorites_view_model.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final FavoritesVM _favoritesVM = FavoritesVM();

  @override
  Widget build(BuildContext context) {
    final _notes = _favoritesVM.query;
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final res = await AppNavigator.navigateToSearch(context);
              setState(() {});
            },
          ),
        ],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: AppDrawer(currPage: Pages.FAVORITES),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  Note note = _notes[index];
                  return NoteWidget(
                    note: note,
                    onDismissed: (direction) {
                      _favoritesVM.deleteNote(note.id);
                      setState(() {});
                    },
                    onTap: () async {
                      Note res = await AppNavigator.navigateToEditNote(
                        context: context,
                        note: note,
                      );
                      if (res == null) {
                        _favoritesVM.deleteNote(note.id);
                        setState(() {});
                      } else {
                        setState(() {
                          note = res;
                        });
                        await _favoritesVM.update(note);
                      }
                    },
                    onLongPress: () async {
                      final res = await AppNavigator.navigateToOptions(
                        context: context,
                        notes: _notes,
                        selected: [note.id],
                      );
                      setState(() {});
                    },
                    onFavTap: () {
                      setState(() {
                        note.favorite = !note.favorite;
                      });
                      _favoritesVM.update(note);
                    },
                  );
                },
                itemCount: _notes.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
