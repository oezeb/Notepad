import 'package:flutter/material.dart';

import '../models/note.dart';
import '../widgets.dart/note_widget.dart';
import '../views_models/options_view_model.dart';

class OptionsPage extends StatefulWidget {
  final List<Note> notes;
  final List<String> selected;

  const OptionsPage({Key key, @required this.notes, @required this.selected})
      : super(key: key);

  @override
  _OptionsPageState createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  OptionsVM _optionsVM;

  @override
  void initState() {
    super.initState();
    _optionsVM = OptionsVM(notes: widget.notes, selected: widget.selected);
  }

  @override
  Widget build(BuildContext context) {
    final List<Note> _notes = _optionsVM.query;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.grey[700],
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: Colors.grey[700],
            ),
            iconSize: 24,
            onPressed: () async {
              await _optionsVM.delete();
              setState(() {});
            },
          ),
          IconButton(
            icon: Icon(
              _optionsVM.favorite ? Icons.star : Icons.star_border,
              color: Colors.grey[700],
            ),
            iconSize: 24,
            onPressed: () async {
              await _optionsVM.switchFavorite();
              setState(() {});
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  Note note = _notes[index];
                  return NoteWidget(
                    note: note,
                    selected: _optionsVM.isSelected(note.id),
                    onTap: () {
                      _optionsVM.switchSelected(note.id);
                      setState(() {});
                    },
                    onFavTap: () {
                      _optionsVM.switchFavorite(note.id);
                      setState(() {});
                    },
                  );
                },
                itemCount: _notes.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
