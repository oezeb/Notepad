import 'package:flutter/material.dart';

import '../models/note.dart';
import '../views/editpage.dart';

class DataSearch extends SearchDelegate<String> {
  BuildContext context;
  final Map<String, Note> notes;

  DataSearch({this.context, this.notes});

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

  _buildListItem(String key) {
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
              children: _spanList(notes[key].title),
            ),
          ),
        ),
        subtitle: RichText(
          maxLines: 10,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            children: _spanList(notes[key].text),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => EditPage(
                noteId: key,
                note: notes[key],
              ),
            ),
          );
        },
      ),
    );
  }

  _buildList(List<String> notesKeys) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return _buildListItem(notesKeys[index]);
      },
      itemCount: notesKeys.length,
    );
  }

  _result() {
    final list = notes.keys.where((key) {
      final regexp = RegExp(".*" + query + ".*", caseSensitive: false);
      return regexp.hasMatch(notes[key].title) ||
          regexp.hasMatch(notes[key].text);
    }).toList();
    return _buildList(list);
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
    return _result();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _result();
  }
}
