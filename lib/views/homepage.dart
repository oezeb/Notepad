import 'package:flutter/material.dart';
import 'package:notepad/data/data.dart';
import 'package:notepad/models/note.dart';
import 'package:notepad/views/editpage.dart';
import 'package:notepad/views/searchpage.dart';

class HomePage extends StatefulWidget {
  final List<String> _titleList;
  final List<List<Note>> _notesList;
  HomePage()
      : _titleList = [
          "Notepad",
          "Favorites",
        ],
        _notesList = [
          allNotes,
          favNotes,
        ];

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedNote;
  int _index;
  String _barTitle;
  Widget _barLeading;
  Color _barColor;
  List<Widget> _barActions;
  List<Widget> _bodyWidgetList;
  List<Widget> _optionsActions;
  List<Widget> _homeActions;

  List<Widget> _iconsList(Note note) {
    Widget favorite = IconButton(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.star_border),
      onPressed: () {
        setState(() {
          note.favorite = !note.favorite;
        });
      },
    );
    Widget stiky = GestureDetector(
      child: Image(
        image: AssetImage('assets/images/pin_icon.png'),
        height: 20,
        width: 20,
      ),
      onTap: () {
        setState(() {
          note.sticky = !note.sticky;
        });
      },
    );
    List<Widget> L = [favorite, stiky];
    if (note != null) {
      if (note.favorite == false) L.remove(favorite);
      if (note.sticky == false) L.remove(stiky);
    }
    return L;
  }

  _buildIcons(Note note) {
    List<Widget> L = [];
    for (var item in _iconsList(note)) {
      L.add(Container(
        margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
        height: 20,
        width: 20,
        child: item,
      ));
    }
    return L;
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
                  _buildIcons(note),
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
            setState(() {
              _selectedNote = note.noteId;
              _barTitle = "";
              _barLeading = IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      _selectedNote = '0';
                      _barTitle = "Notepad";
                      _barLeading = null;
                      _barActions = _homeActions;
                      _barColor = Theme.of(context).appBarTheme.backgroundColor;
                    });
                  });
              _barActions = _optionsActions;
              _barColor = Colors.white;
            });
            //TODO: on long press show options(delete,..)
          },
        ),
      ),
    );
  }

  _buildList(List<Note> notes) {
    return ListView.builder(
        itemCount: allNotes.length,
        itemBuilder: (context, index) {
          return _buildListItem(notes[index]);
        });
  }

  @override
  void initState() {
    super.initState();
    _selectedNote = '0';
    _index = 0;
    _homeActions = [
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => SearchPage(),
            ),
          );
        },
      ),
    ];
    _optionsActions = _iconsList(null) +
        [
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => SearchPage(),
                ),
              );
            },
          ),
        ];
    _barTitle = widget._titleList[_index];
    _barLeading = null;
    _barActions = _homeActions;
    _barColor = null; //Theme.of(context).appBarTheme.backgroundColor;
    _bodyWidgetList = [];
    for (var notes in widget._notesList) {
      _bodyWidgetList.add(_buildList(notes));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _barLeading,
        title: Text(_barTitle),
        actions: _barActions,
        backgroundColor: _barColor,
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
              selected: _index == 0,
              onTap: () {
                setState(() {
                  _index = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Favorites"),
              selected: _index == 1,
              onTap: () {
                setState(() {
                  _index = 1;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _buildList(widget._notesList[_index]),
      floatingActionButton: _index == 0
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => EditPage(
                      note: Note(),
                    ),
                  ),
                );
              },
            )
          : null,
    );
  }
}
