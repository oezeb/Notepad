import 'package:flutter/material.dart';
import 'package:notepad/data/data.dart';
import 'package:notepad/models/note.dart';
import 'package:notepad/views/editpage.dart';
import 'package:notepad/views/searchpage.dart';
import 'package:notepad/widgets.dart/SideBar.dart';
import 'package:notepad/widgets.dart/noteslist.dart';

class HomePage extends StatefulWidget {
  final String title;

  HomePage({Key key, this.title});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
        actions: [
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
        ],
      ),
      drawer: SideBar(),
      body: NotesList(
        notes: myNotes,
      ),
      floatingActionButton: FloatingActionButton(
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
      ),
    );
  }
}
