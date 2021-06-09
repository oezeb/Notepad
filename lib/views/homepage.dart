import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/constants.dart';
import '../views_models/home_view_model.dart';
import '../views/datasearch.dart';
import '../views/editpage.dart';
import '../views_models/edit_view_model.dart';
import '../models/note.dart';

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
  List<Note> _notes;

  _showEditPage(Note note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ChangeNotifierProvider(
          create: (context) => EditVM(note),
          child: EditPage(),
        ),
      ),
    );
    await _homeVM.reload();
  }

  _headIcons(Note note) {
    List<Widget> L = [
      IconButton(
        icon: note.favorite ? Icon(Icons.star) : Icon(Icons.star_border),
        iconSize: 24,
        onPressed: () async {
          await _homeVM.switchFav(note.id);
        },
      )
    ];
    if (_selectedNote == note.id)
      L.add(IconButton(
        icon: Icon(Icons.delete_outline),
        iconSize: 24,
        onPressed: () async {
          await _homeVM.deleteNote(note.id);
        },
      ));
    return L;
  }

  _buildListItem(Note note) {
    return Dismissible(
      key: Key(note.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        await _homeVM.deleteNote(note.id);
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: _selectedNote == note.id
              ? Colors.grey
              : Theme.of(context).scaffoldBackgroundColor,
          border: Border.all(
            color: _selectedNote == note.id ? Colors.black : Colors.grey,
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
            if (_selectedNote == '0') {
              await _showEditPage(note);
            } else {
              setState(() {
                _selectedNote = note.id;
              });
            }
          },
          onLongPress: () {
            setState(() {
              _selectedNote = note.id;
            });
          },
        ),
      ),
    );
  }

  _buildListView() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return _buildListItem(_notes[index]);
      },
      itemCount: _notes.length,
    );
  }

  @override
  void initState() {
    super.initState();
    _selectedNote = '0';
    _currPage = Pages.ALL_NOTES;
    _notes = [];
  }

  @override
  Widget build(BuildContext context) {
    _homeVM = Provider.of<HomeVM>(context);

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
                final notes = await _homeVM.notesToDisplay(Pages.ALL_NOTES);
                showSearch(
                  context: context,
                  delegate: DataSearch(context),
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
      body: FutureBuilder(
        future: _homeVM.notesToDisplay(_currPage),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done)
            _notes = snapshot.data;
          return Center(
            child: Column(
              children: [
                Expanded(
                  child: _buildListView(),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: _currPage == Pages.ALL_NOTES && _selectedNote == '0'
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () async {
                await _showEditPage(Note());
              },
            )
          : null,
    );
  }
}
