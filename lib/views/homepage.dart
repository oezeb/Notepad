import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:notepad/data/data.dart';
import 'package:notepad/models/note.dart';
import 'package:notepad/views/editpage.dart';

class HomePage extends StatefulWidget {
  final String title;

  HomePage({Key key, this.title});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  _buildList() {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return _buildListItem(notes[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.menu,
          ),
          onPressed: () {
            //TODO: show menu
          },
        ),
        title: Text(
          widget.title,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              //TODO: show search bar
            },
          ),
        ],
      ),
      body: _buildList(),
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
