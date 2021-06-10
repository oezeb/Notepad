import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets.dart/appdrawer.dart';
import '../models/note.dart';
import '../views/datasearch.dart';
import '../views_models/home_view_model.dart';
import '../widgets.dart/noteslistview.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HomeVM _homeVM = Provider.of<HomeVM>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Notepad'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              await showSearch(
                context: context,
                delegate: DataSearch(context),
              );
              _homeVM.reload();
            },
          ),
        ],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: AppDrawer(currPage: Pages.ALL_NOTES),
      body: FutureBuilder(
        future: _homeVM.query(),
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
                    parentVM: _homeVM,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await NotesListView.showEditPage(context, Note());
          await _homeVM.reload();
        },
      ),
    );
  }
}
