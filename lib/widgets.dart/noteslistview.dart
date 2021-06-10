import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../views/editpage.dart';
import '../views/optionspage.dart';
import '../views_models/edit_view_model.dart';
import '../views_models/options_view_model.dart';

class NotesListView extends StatelessWidget {
  final List<Note> notes;
  final parentVM;
  final Set<String> selectedNotes;

  const NotesListView({Key key, this.notes, this.parentVM, this.selectedNotes})
      : super(key: key);

  static showEditPage(BuildContext context, Note note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (context) => EditVM(note),
          child: EditPage(),
        ),
      ),
    );
  }

  _title(Note note) {
    // Icons
    List<Widget> widgets = [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(child: Text('')),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 0),
            child: GestureDetector(
              child: note.favorite ? Icon(Icons.star) : Icon(Icons.star_border),
              onTap: () async {
                await parentVM.switchFav(note.id);
              },
            ),
          ),
        ],
      ),
    ];

    //Title
    if (note.title != null && note.title != '') {
      widgets.add(
        Row(
          children: [
            Text(
              note.title,
              maxLines: 1,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 5.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: widgets,
            ),
          ),
        ],
      ),
    );
  }

  _text(Note note) {
    if (note.text == null || note.text == '') return null;
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              note.text,
              style: TextStyle(
                fontSize: 16,
              ),
              maxLines: 10,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  _buildListItem(BuildContext context, Note note) {
    bool selected =
        selectedNotes == null ? false : selectedNotes.contains(note.id);
    return Dismissible(
      key: Key(note.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        await parentVM.deleteNote(note.id);
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? Colors.black : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(10.0),
          color: selected
              ? Colors.grey
              : Theme.of(context).scaffoldBackgroundColor,
        ),
        child: ListTile(
          title: _title(note),
          subtitle: _text(note),
          contentPadding: const EdgeInsets.only(left: 8.0, right: 8.0),
          onTap: () async {
            if (selectedNotes == null) {
              await showEditPage(context, note);
              await parentVM.reload();
            } else {
              parentVM.switchSelected(note.id);
            }
          },
          onLongPress: () async {
            if (selectedNotes == null) {
              final List<Note> notes = await parentVM.query();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                    create: (context) =>
                        OptionsVM(notes: notes, selected: [note.id]),
                    child: OptionsPage(),
                  ),
                ),
              );
              await parentVM.reload();
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return _buildListItem(context, notes[index]);
      },
      itemCount: notes.length,
    );
  }
}
