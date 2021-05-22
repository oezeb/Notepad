import 'package:flutter/material.dart';
import 'package:notepad/models/note.dart';
import 'package:notepad/views/editpage.dart';

class NotesList extends StatefulWidget {
  final List<Note> notes;

  const NotesList({Key key, this.notes}) : super(key: key);

  @override
  _NotesListState createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  _buildListItem(Note note) {
    return Dismissible(
      key: Key(note.noteId),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        //TODO: delete note from database
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.0)),
        child: ListTile(
          title: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              note.title,
              maxLines: 1,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          subtitle: Text(
            note.text,
            style: TextStyle(
              fontSize: 16,
            ),
            maxLines: 11,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => EditPage(
                  note: note,
                ),
              ),
            );
          },
          onLongPress: () {
            //TODO: on long press show options(delete,..)
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.notes.length,
      itemBuilder: (context, index) {
        return _buildListItem(widget.notes[index]);
      },
    );
  }
}
