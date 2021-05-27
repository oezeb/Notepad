import 'package:flutter/material.dart';
import 'package:notepad/data/data.dart';
import 'package:notepad/models/note.dart';

class EditPage extends StatefulWidget {
  final Note note;
  final TextEditingController _titleController;
  final TextEditingController _noteController;
  final DateTime _editTime;

  EditPage(Note note)
      : this.note = note,
        this._titleController = TextEditingController(text: note.title),
        this._noteController = TextEditingController(text: note.text),
        this._editTime = note.editDate;

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  Note _note;
  bool _saved;
  bool _edited;

  _dateString(DateTime date) {
    String ans = "Edited   ";
    DateTime now = DateTime.now();
    //this year
    if (now.year == date.year) {
      //Today
      if (now.month * 10 + now.day == date.month * 10 + date.day) {
        ans += (date.hour % 12).toString() + " : " + date.minute.toString();
        ans += (date.hour <= 12) ? " AM" : " PM";
      } else {
        ans += getMonth(date.month).toString() + " " + date.day.toString();
      }
    } else {
      ans += date.year.toString() +
          "/" +
          date.month.toString() +
          "/" +
          date.day.toString();
    }
    return ans;
  }

  _saveNote() async {
    if (_note.title != "" || _note.text != "") {
      setState(() {
        if (_edited == true) _note.editDate = DateTime.now();
      });
      final res = await dataBase.saveNote(_note);
      setState(() {
        _saved = res;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _note = widget.note;
    _saved = true;
    _edited = false;
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
          onPressed: () {
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
                await _saveNote();
              }),
          IconButton(
            icon: _note.favorite
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
                _note.favorite = !_note.favorite;
              });
              await dataBase.save();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.black,
            ),
            onPressed: () async {
              await dataBase.deleteNote(_note.noteId);
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
              controller: widget._titleController,
              onChanged: (title) {
                setState(() {
                  if (_note.title != title) {
                    _saved = false;
                    _edited = true;
                    _note.title = title;
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
              controller: widget._noteController,
              onChanged: (text) {
                setState(() {
                  if (_note.text != text) {
                    _saved = false;
                    _edited = true;
                    _note.text = text;
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
            _dateString(widget.note.editDate),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }
}

String getMonth(int month) {
  switch (month) {
    case 1:
      return "Jan";
    case 2:
      return "Feb";
    case 3:
      return "Mar";
    case 4:
      return "Apr";
    case 5:
      return "May";
    case 6:
      return "Jun";
    case 7:
      return "Jul";
    case 8:
      return "Aug";
    case 9:
      return "Sep";
    case 10:
      return "Oct";
    case 11:
      return "Nov";
    case 12:
      return "Dec";
  }
  return "";
}
