import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets.dart/appdrawer.dart';
import '../models/note.dart';
import '../views/datasearch.dart';
import '../views_models/favorites_view_model.dart';
import '../widgets.dart/noteslistview.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FavoritesVM _favoritesVM = Provider.of<FavoritesVM>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              await showSearch(
                context: context,
                delegate: DataSearch(context),
              );
              _favoritesVM.reload();
            },
          ),
        ],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: AppDrawer(currPage: Pages.FAVORITES),
      body: FutureBuilder(
        future: _favoritesVM.query(),
        builder: (context, snapshot) {
          List<Note> notes = [];
          if (snapshot.connectionState == ConnectionState.done)
            notes = snapshot.data;
          return Center(
            child: Column(
              children: [
                Expanded(
                  child: NotesListView(
                    notes: notes,
                    parentVM: _favoritesVM,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
