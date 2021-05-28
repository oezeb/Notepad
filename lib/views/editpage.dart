import 'package:flutter/material.dart';

import '../views_models/edit_view_model.dart';
import '../utils/date.dart';

class EditPage extends StatefulWidget {
  final String noteId;
  final note;
  EditPage({this.noteId, this.note});
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  bool _saved;
  TextEditingController _titleCtrl;
  TextEditingController _textCtrl;
  EditVM _editVM;

  @override
  void initState() {
    super.initState();
    _editVM = EditVM(key: widget.noteId, note: widget.note);
    _saved = true;
    _titleCtrl = TextEditingController(text: _editVM.note.title);
    _textCtrl = TextEditingController(text: _editVM.note.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () async {
            await _editVM.saveNote();
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.save,
                color: _saved == true ? Colors.black : Colors.red,
              ),
              onPressed: () async {
                bool res = await _editVM.saveNote();
                setState(() {
                  _saved = res;
                });
              }),
          IconButton(
            icon: _editVM.note.favorite
                ? Icon(
                    Icons.star,
                    color: Colors.black,
                  )
                : Icon(
                    Icons.star_border,
                    color: Colors.black,
                  ),
            onPressed: () async {
              setState(() {
                _editVM.note.favorite = !_editVM.note.favorite;
              });
              await _editVM.saveNote();
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
              controller: _titleCtrl,
              onChanged: (title) {
                setState(() {
                  if (_editVM.note.title != title) {
                    _saved = false;
                    _editVM.note.title = title;
                  }
                });
              },
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
              controller: _textCtrl,
              onChanged: (text) {
                setState(() {
                  if (_editVM.note.text != text) {
                    _saved = false;
                    _editVM.note.text = text;
                  }
                });
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            Date.getString(widget.note.editDate),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }
}
