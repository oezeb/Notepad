import 'package:flutter/material.dart';
import 'package:notepad/data/data.dart';
import 'package:notepad/models/note.dart';
import 'package:notepad/views/editpage.dart';
import 'package:notepad/views/searchpage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedNote;
  String _currPage;
  Map<String, Map<String, Note>> _notesList;

  _headIcons(Note note) {
    List<Widget> L = [
      IconButton(
        icon: note.favorite ? Icon(Icons.star) : Icon(Icons.star_border),
        iconSize: 24,
        onPressed: () {
          allNotes[note.noteId].favorite = !allNotes[note.noteId].favorite;
          setState(() {
            _notesList = getNotesMap();
          });
        },
      )
    ];
    if (_selectedNote == note.noteId)
      L.add(IconButton(
        icon: Icon(Icons.delete_outline),
        iconSize: 24,
        onPressed: () {
          deleteNote(note.noteId);
          setState(() {
            _notesList = getNotesMap();
          });
        },
      ));
    return L;
  }

  _buildListItem(Note note) {
    return Dismissible(
      key: Key(note.noteId),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        deleteNote(note.noteId);
        setState(() {
          _notesList = getNotesMap();
        });
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: _selectedNote == note.noteId
                ? Colors.grey
                : Theme.of(context).scaffoldBackgroundColor,
            border: Border.all(
                color:
                    _selectedNote == note.noteId ? Colors.black : Colors.grey),
            borderRadius: BorderRadius.circular(10.0)),
        child: ListTile(
          title: Padding(
            padding: EdgeInsets.all(5.0),
            child: Row(
              children: <Widget>[
                    Expanded(
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
                  ] +
                  _headIcons(note),
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
            if (int.parse(_selectedNote) == 0) {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => EditPage(note),
                ),
              );
              setState(() {
                _notesList = getNotesMap();
              });
            } else {
              setState(() {
                _selectedNote = note.noteId;
              });
            }
          },
          onLongPress: () {
            setState(() {
              _selectedNote = note.noteId;
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
    _selectedNote = '0';
    _currPage = "allNotes";
    _notesList = getNotesMap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currPage == 'allNotes' ? 'Notepad' : 'Favorites'),
        actions: [
          IconButton(
            icon: _selectedNote == '0'
                ? Icon(Icons.search)
                : Icon(Icons.keyboard_return),
            onPressed: () {
              if (int.parse(_selectedNote) == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => SearchPage(),
                  ),
                );
              } else {
                setState(() {
                  _selectedNote = '0';
                });
              }
            },
          ),
        ],
        iconTheme: IconThemeData(color: Colors.black),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Notepad",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            ListTile(
              title: Text("All Notes"),
              selected: _currPage == 'allNotes',
              onTap: () {
                setState(() {
                  _currPage = 'allNotes';
                  _selectedNote = '0';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Favorites"),
              selected: _currPage == 'favorites',
              onTap: () {
                setState(() {
                  _currPage = 'favorites';
                  _selectedNote = '0';
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _buildList(_notesList[_currPage]),
      floatingActionButton: _currPage == 'allNotes' && _selectedNote == '0'
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        EditPage(Note(getNextId())),
                  ),
                );
                setState(() {
                  _notesList = getNotesMap();
                });
              },
            )
          : null,
    );
  }
}
