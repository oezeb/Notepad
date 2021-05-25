import 'package:flutter/material.dart';
import 'package:notepad/data/data.dart';
import 'package:notepad/models/note.dart';
import 'package:notepad/views/editpage.dart';
import 'package:notepad/views/datasearch.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedNote;
  String _currPage;

  _headIcons(Note note) {
    List<Widget> L = [
      IconButton(
        icon: note.favorite ? Icon(Icons.star) : Icon(Icons.star_border),
        iconSize: 24,
        onPressed: () async {
          note.favorite = !note.favorite;
          await dataBase.saveNote(note);
        },
      )
    ];
    if (_selectedNote == note.noteId)
      L.add(IconButton(
        icon: Icon(Icons.delete_outline),
        iconSize: 24,
        onPressed: () async {
          await dataBase.deleteNote(note.noteId);
        },
      ));
    return L;
  }

  _buildListItem(Note note) {
    return Dismissible(
      key: Key(note.noteId),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        await dataBase.deleteNote(note.noteId);
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
          onTap: () {
            if (_selectedNote == '0') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => EditPage(note),
                ),
              );
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
              if (_selectedNote == '0') {
                showSearch(context: context, delegate: DataSearch(context));
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
      body: StreamBuilder<Map<String, Map<String, Note>>>(
        stream: dataBase.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: Container(
                margin: EdgeInsets.all(50),
                child: LinearProgressIndicator(minHeight: 5),
              ),
            );
          else
            return Center(
              child: Column(
                children: [
                  Expanded(child: _buildList(snapshot.data[_currPage]))
                ],
              ),
            );
        },
      ),
      floatingActionButton: _currPage == 'allNotes' && _selectedNote == '0'
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        EditPage(Note(dataBase.nextId)),
                  ),
                );
              },
            )
          : null,
    );
  }
}
