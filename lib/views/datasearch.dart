import 'package:flutter/material.dart';
import 'package:notepad/data/data.dart';
import 'package:notepad/models/note.dart';
import 'package:notepad/views/editpage.dart';

class DataSearch extends SearchDelegate<String> {
  BuildContext context;
  DataSearch(this.context);
  _span(String text) {
    return TextSpan(
      text: text,
      style: TextStyle(
        color: Colors.grey[700],
        fontSize: text == query ? 24.0 : 16.0,
        fontWeight: text == query ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  _spanList(String text) {
    final bunks = text.split(RegExp(query));
    final len = bunks.length;
    List<TextSpan> ans = [];
    int i = 0;
    if (bunks[0] == "")
      i++;
    else
      ans.add(_span(bunks[i++]));
    while (i < len) ans.addAll([_span(query), _span(bunks[i++])]);
    return ans;
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
              text: "",
              children: _spanList(note.title),
            ),
          ),
        ),
        subtitle: RichText(
          maxLines: 10,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            text: "",
            children: _spanList(note.text),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => EditPage(note),
            ),
          );
        },
      ),
    );
  }

  _buildList(var notes) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return _buildListItem(notes[index]);
      },
      itemCount: notes.length,
    );
  }

  _result() {
    final all = dataBase.allNotes;
    final list = all.where((element) {
      final regexp = RegExp(".*" + query + ".*");
      final bunks =
          element.title.split(RegExp(" ")) + element.text.split(RegExp(" "));
      for (var item in bunks) {
        if (regexp.hasMatch(item)) return true;
      }
      return false;
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
