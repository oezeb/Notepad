import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../views_models/options_view_model.dart';
import '../widgets.dart/noteslistview.dart';

class OptionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final OptionsVM _optionsVM = Provider.of<OptionsVM>(context);
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
            },
          ),
          IconButton(
            icon: Icon(
              _optionsVM.isfav() ? Icons.star : Icons.star_border,
              color: Colors.grey[700],
            ),
            iconSize: 24,
            onPressed: () async {
              await _optionsVM.switchFav();
            },
          )
        ],
      ),
      body: NotesListView(
        notes: _optionsVM.notes,
        parentVM: _optionsVM,
        selectedNotes: _optionsVM.selected,
      ),
    );
  }
}
