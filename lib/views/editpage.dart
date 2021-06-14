import 'package:flutter/material.dart';
import 'package:notepad/models/note.dart';
import 'package:notepad/views_models/edit_view_model.dart';

class EditPage extends StatefulWidget {
  final Note note;
  EditPage({Key key, @required this.note}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  EditVM _editVM;

  @override
  void initState() {
    super.initState();
    _editVM = EditVM(widget.note);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _editVM.note);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () async {
              Navigator.pop(context, _editVM.note);
            },
          ),
          actions: [
            IconButton(
              icon: _editVM.favorite
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
                  _editVM.favorite = !_editVM.favorite;
                });
              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.black,
              ),
              onPressed: () async {
                await _editVM.delete();
                Navigator.pop(context, null);
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
                  await _editVM.update();
                },
                controller: _editVM.titleCtrl,
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
                  await _editVM.update();
                },
                controller: _editVM.textCtrl,
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
      ),
    );
  }
}
