import 'package:flutter/material.dart';
import 'package:notepad/models/note.dart';

class EditPage extends StatefulWidget {
  final Note note;
  EditPage({this.note});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController _titleController;
  TextEditingController _noteController;

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

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _noteController = TextEditingController(text: widget.note.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            //TODO: save edited note back in the data base
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              //TODO: delete current note from data base
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
              controller: _titleController,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Note",
                ),
                style: TextStyle(fontSize: 17.0),
                maxLines: null,
                controller: _noteController,
              ),
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
