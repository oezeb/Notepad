import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../views_models/edit_view_model.dart';

class EditPage extends StatelessWidget {
  EditPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EditVM _editVM = Provider.of<EditVM>(context);
    final _titleCtrl = TextEditingController(text: _editVM.title);
    final _textCtrl = TextEditingController(text: _editVM.text);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: _editVM.isFavorite()
                ? Icon(
                    Icons.star,
                    color: Colors.black,
                  )
                : Icon(
                    Icons.star_border,
                    color: Colors.black,
                  ),
            onPressed: () async {
              await _editVM.switchFav();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.black,
            ),
            onPressed: () async {
              await _editVM.delete();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Title",
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 25.0),
              minLines: 1,
              maxLines: 5,
              onChanged: (title) async {
                await _editVM.setTitle(title);
              },
              controller: _titleCtrl,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Note",
              ),
              style: TextStyle(fontSize: 17.0),
              maxLines: null,
              onChanged: (text) async {
                await _editVM.setText(text);
              },
              controller: _textCtrl,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            _editVM.editDate,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }
}
