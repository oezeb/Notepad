import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../views_models/home_view_model.dart';
import '../models/notemap.dart';
import '../views/datasearch.dart';
import '../views/editpage.dart';
import '../models/note.dart';
import '../main.dart';

class HomePage extends StatefulWidget {
  final title;

  const HomePage({Key key, this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedNote;
  Pages _currPage;
  HomeVM _homeVM;

  _showEditPage(String key) {
    Note note = _homeVM.getNote(key);
    if (key == null) key = '0';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => EditPage(
          noteId: key,
          note: note,
        ),
      ),
    );
  }

  _headIcons(String key) {
    List<Widget> L = [
      IconButton(
        icon: _homeVM.getNote(key).favorite
            ? Icon(Icons.star)
            : Icon(Icons.star_border),
        iconSize: 24,
        onPressed: () async {
          await _homeVM.switchFav(key);
        },
      )
    ];
    if (_selectedNote == key)
      L.add(IconButton(
        icon: Icon(Icons.delete_outline),
        iconSize: 24,
        onPressed: () async {
          await _homeVM.deleteNote(key);
        },
      ));
    return L;
  }

  _buildListItem(String key) {
    Note note = _homeVM.getNote(key);
    return Dismissible(
      key: Key(key),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        await _homeVM.deleteNote(key);
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: _selectedNote == key
              ? Colors.grey
              : Theme.of(context).scaffoldBackgroundColor,
          border: Border.all(
            color: _selectedNote == key ? Colors.black : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
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
                  _headIcons(key),
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
              _showEditPage(key);
            } else {
              setState(() {
                _selectedNote = key;
              });
            }
          },
          onLongPress: () {
            setState(() {
              _selectedNote = key;
            });
          },
        ),
      ),
    );
  }

  _buildListView(List<String> notesKeys) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return _buildListItem(notesKeys[index]);
      },
      itemCount: notesKeys.length,
    );
  }

  @override
  void initState() {
    super.initState();
    _selectedNote = '0';
    _currPage = Pages.ALL_NOTES;
    _homeVM = HomeVM();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currPage == Pages.ALL_NOTES ? widget.title : 'Favorites'),
        actions: [
          IconButton(
            icon: _selectedNote == '0'
                ? Icon(Icons.search)
                : Icon(Icons.keyboard_return),
            onPressed: () async {
              if (_selectedNote == '0') {
                final notes = _homeVM.notesToDisplay(Pages.SEARCH);
                showSearch(
                  context: context,
                  delegate: DataSearch(
                    context: context,
                    notes: notes,
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
              selected: _currPage == Pages.ALL_NOTES,
              onTap: () {
                setState(() {
                  _currPage = Pages.ALL_NOTES;
                  _selectedNote = '0';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Favorites"),
              selected: _currPage == Pages.FAVORITES,
              onTap: () {
                setState(() {
                  _currPage = Pages.FAVORITES;
                  _selectedNote = '0';
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<NoteMap>(
        stream: noteDataBase.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: Container(
                margin: EdgeInsets.all(50),
                child: LinearProgressIndicator(minHeight: 5),
              ),
            );
          else {
            _homeVM.noteMap = snapshot.data.data;
            return Center(
              child: Column(
                children: [
                  Expanded(
                    child: _buildListView(
                      _homeVM.notesToDisplay(_currPage),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: _currPage == Pages.ALL_NOTES && _selectedNote == '0'
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () async {
                String key = await _homeVM.nextKey();
                _showEditPage(key);
              },
            )
          : null,
    );
  }
}
