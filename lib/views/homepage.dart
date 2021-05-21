import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:notepad/data/data.dart';
import 'package:notepad/models/note.dart';

class HomePage extends StatefulWidget {
  final String title;

  HomePage({Key key, this.title});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _buildListItem(Note note) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Dismissible(
          key: Key(note.noteId),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
          ),
          onDismissed: (direction) {
            //TODO: delete note from database
          },
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
              //TODO: on tap edit note
            },
            onLongPress: () {
              //TODO: on long press show options(delete,..)
            },
          ),
        ),
        SizedBox(
          height: 1,
          child: Container(
            color: Colors.blue,
          ),
        ),
      ],
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
          onPressed: () {},
        ),
        title: Text(
          widget.title,
        ),
      ),
      body: _buildList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
