import 'package:flutter/material.dart';
import 'package:notepad/models/note.dart';

class NoteWidget extends StatelessWidget {
  final Note note;
  final bool selected;
  final Function onDismissed;
  final Function onTap;
  final Function onLongPress;
  final Function onFavTap;

  const NoteWidget({
    Key key,
    this.note,
    this.onDismissed,
    this.onTap,
    this.onLongPress,
    this.onFavTap,
    this.selected = false,
  }) : super(key: key);

  _noteHeadWidget(Note note, Function onFavTap) {
    // Icons
    List<Widget> widgets = [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(child: Text('')),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 0),
            child: GestureDetector(
              child: note.favorite ? Icon(Icons.star) : Icon(Icons.star_border),
              onTap: onFavTap,
            ),
          ),
        ],
      ),
    ];

    //Title
    if (note.title != null && note.title != '') {
      widgets.add(
        Row(
          children: [
            Text(
              note.title,
              maxLines: 1,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 5.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: widgets,
            ),
          ),
        ],
      ),
    );
  }

  _noteBodyWidget(Note note) {
    if (note.text == null || note.text == '') return null;
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              note.text,
              style: TextStyle(
                fontSize: 16,
              ),
              maxLines: 10,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(note.id),
      direction: DismissDirection.endToStart,
      onDismissed: onDismissed,
      child: Container(
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          border: Border.all(color: selected ? Colors.black : Colors.grey),
          borderRadius: BorderRadius.circular(10.0),
          color: selected
              ? Colors.grey
              : Theme.of(context).scaffoldBackgroundColor,
        ),
        child: ListTile(
          title: _noteHeadWidget(note, onFavTap),
          subtitle: _noteBodyWidget(note),
          contentPadding: const EdgeInsets.only(left: 8.0, right: 8.0),
          onTap: onTap,
          onLongPress: onLongPress,
        ),
      ),
    );
  }
}
