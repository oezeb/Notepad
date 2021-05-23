import 'package:flutter/material.dart';
import 'package:notepad/data/data.dart';
import 'package:notepad/models/note.dart';
import 'package:notepad/views/editpage.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _controller;
  Map<String, Note> _notes;

  _buildListItem(Note note) {
    return Dismissible(
      key: Key(note.noteId),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        deleteNote(note.noteId);
        setState(() {
          _notes = allNotes;
        });
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.0)),
        child: ListTile(
          title: Padding(
            padding: EdgeInsets.all(5.0),
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
            maxLines: 10,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => EditPage(note),
              ),
            );
            setState(() {
              _notes = allNotes;
            });
          },
        ),
      ),
    );
  }

  _buildList(Map<String, Note> notes) {
    List<Widget> list = [];
    notes.forEach((key, value) {
      list.add(_buildListItem(value));
    });
    return ListView(
      children: list,
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _notes = allNotes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TextField(
          controller: _controller,
          style: TextStyle(fontSize: 18),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "search your notes",
          ),
        ),
      ),
      body: _buildList(_notes),
    );
  }
}
