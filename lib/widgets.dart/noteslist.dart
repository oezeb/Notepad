import 'package:flutter/material.dart';
import 'package:notepad/models/note.dart';
import 'package:notepad/views/editpage.dart';
import 'package:notepad/views/homepage.dart';

class NotesList extends StatefulWidget {
  final List<Note> notes;
  final HomePage parent;
  String selectedNote;

  get selecttedNote => selectedNote;

  NotesList({Key key, this.notes, this.parent})
      : selectedNote = '0',
        super(key: key);

  @override
  _NotesListState createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  final List<Widget> _iconsList = [
    IconButton(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.alarm_on),
      onPressed: () {},
    ),
    IconButton(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.star_border),
      onPressed: () {},
    ),
    GestureDetector(
      child: Image(image: AssetImage('assets/images/pin_icon.png')),
      onTap: () {},
    ),
  ];

  _buildTitleAndIcons(String title) {
    List<Widget> L = [
      Expanded(
        child: Text(
          title,
          maxLines: 1,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ];
    for (var item in _iconsList) {
      L.add(Container(
        margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
        height: 20,
        width: 20,
        child: item,
      ));
    }

    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Row(
        children: L,
      ),
    );
  }

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
            color: widget.selectedNote == note.noteId
                ? Colors.grey
                : Theme.of(context).scaffoldBackgroundColor,
            border: Border.all(
                color: widget.selectedNote == note.noteId
                    ? Colors.black
                    : Colors.grey),
            borderRadius: BorderRadius.circular(10.0)),
        child: ListTile(
          title: _buildTitleAndIcons(note.title),
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
            setState(() {
              widget.selectedNote = note.noteId;
            });
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
