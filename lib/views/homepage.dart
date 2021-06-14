import 'package:flutter/material.dart';

import '../widgets.dart/note_widget.dart';
import '../utils/navigator.dart';
import '../views_models/home_view_model.dart';
import '../widgets.dart/appdrawer.dart';
import '../models/note.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeVM _homeVM = HomeVM();

  @override
  Widget build(BuildContext context) {
    final _notes = _homeVM.query;
    return Scaffold(
      appBar: AppBar(
        title: Text('Notepad'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              await AppNavigator.navigateToSearch(context);
              setState(() {});
            },
          ),
        ],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: AppDrawer(currPage: Pages.ALL_NOTES),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  Note note = _notes[index];
                  return NoteWidget(
                    note: note,
                    onDismissed: (DismissDirection direction) {
                      _homeVM.deleteNote(note.id);
                      setState(() {});
                    },
                    onTap: () async {
                      Note res = await AppNavigator.navigateToEditNote(
                        context: context,
                        note: note,
                      );
                      if (res == null) {
                        _homeVM.deleteNote(note.id);
                        setState(() {});
                      } else {
                        setState(() {
                          note = res;
                        });
                        await _homeVM.update(note);
                      }
                    },
                    onLongPress: () async {
                      await AppNavigator.navigateToOptions(
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
                      _homeVM.update(note);
                    },
                  );
                },
                itemCount: _notes.length,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final note = await AppNavigator.navigateToEditNote(
            context: context,
            note: Note(),
          );
          if (note != null) {
            setState(() {
              _homeVM.insert(note);
            });
          }
        },
      ),
    );
  }
}
