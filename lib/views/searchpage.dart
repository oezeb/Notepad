import 'package:flutter/material.dart';
import 'package:notepad/utils/navigator.dart';
import 'package:notepad/views_models/search_view_model.dart';

import '../models/note.dart';

class SearchPage extends SearchDelegate<String> {
  final BuildContext context;
  final SearchVM _searchVM;

  SearchPage({@required this.context}) : _searchVM = SearchVM();

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
        onTap: () async {
          Note res = await AppNavigator.navigateToEditNote(
            context: context,
            note: note,
          );
          if (res == null) {
            _searchVM.delete(note.id);
          } else {
            note = res;
            _searchVM.update(note);
          }
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

  List<Note> get _searchResult => _searchVM.query.where(
        (note) {
          final regexp = RegExp(".*" + query + ".*", caseSensitive: false);
          return regexp.hasMatch(note.title) || regexp.hasMatch(note.text);
        },
      ).toList();

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
    return _buildList(_searchResult);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildList(_searchResult);
  }
}
