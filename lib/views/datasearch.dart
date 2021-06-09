import 'package:flutter/material.dart';
import 'package:notepad/views_models/edit_view_model.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import '../main.dart';
import '../models/note.dart';
import '../views/editpage.dart';

class DataSearch extends SearchDelegate<String> {
  final BuildContext context;

  DataSearch(this.context);

  // Use span to highlight matched element
  _span(String text) {
    return TextSpan(
      text: text,
      style: TextStyle(
        color: Colors.grey[700],
        fontSize: text.toLowerCase() == query.toLowerCase() ? 24.0 : 16.0,
        fontWeight: text.toLowerCase() == query.toLowerCase()
            ? FontWeight.bold
            : FontWeight.normal,
      ),
    );
  }

  _spanList(String text) {
    if (query == "") {
      return <InlineSpan>[_span(text)];
    } else {
      var curr = -query.length;
      var prev = 0;
      List<TextSpan> ans = [];
      while (true) {
        curr = text
            .toLowerCase()
            .indexOf(query.toLowerCase(), curr + query.length);
        if (curr < 0) {
          ans.add(_span(text.substring(prev)));
          break;
        }

        ans.addAll(
          [
            _span(text.substring(prev, curr)),
            _span(text.substring(curr, curr + query.length)),
          ],
        );
        prev = curr + query.length;
      }
      return ans;
    }
  }

  _buildListItem(Note note) {
    return Container(
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10.0)),
      child: ListTile(
        title: Padding(
          padding: EdgeInsets.all(5.0),
          child: RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: _spanList(note.title),
            ),
          ),
        ),
        subtitle: RichText(
          maxLines: 10,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            children: _spanList(note.text),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => ChangeNotifierProvider(
                create: (context) => EditVM(note),
                child: EditPage(),
              ),
            ),
          );
        },
      ),
    );
  }

  _buildList(List<Note> notes) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return _buildListItem(notes.elementAt(index));
      },
      itemCount: notes.length,
    );
  }

  Future<List<Note>> _result() async {
    Map<String, Note> map = await db.query();
    return map.values.where(
      (note) {
        final regexp = RegExp(".*" + query + ".*", caseSensitive: false);
        return regexp.hasMatch(note.title) || regexp.hasMatch(note.text);
      },
    ).toList();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildList(snapshot.data);
        } else {
          return Center(
            child: Container(
              margin: EdgeInsets.all(50),
              child: LinearProgressIndicator(minHeight: 5),
            ),
          );
        }
      },
      future: _result(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildList(snapshot.data);
        } else {
          return Center(
            child: Container(
              margin: EdgeInsets.all(50),
              child: LinearProgressIndicator(minHeight: 5),
            ),
          );
        }
      },
      future: _result(),
    );
  }
}
