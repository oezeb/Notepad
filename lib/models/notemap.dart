import 'dart:convert';

import '../models/note.dart';

class NoteMap {
  Map<String, Note> data;

  NoteMap({this.data});

  NoteMap.fromJson(Map<String, dynamic> json) : this.data = {} {
    var ans = json;
    ans.forEach(
      (key, value) {
        data[key] = Note.fromJson(value);
      },
    );
  }

  toJson() {
    Map<String, dynamic> json = {};
    data.forEach(
      (key, value) {
        json[key] = value.toJson();
      },
    );
    return json;
  }

  static NoteMap fromString(String source) {
    try {
      // trying to use the built in function to parse Json
      return NoteMap.fromJson(json.decode(source));
    } catch (err) {
      // try to get a minimum data from the string
      // sample == {"1": {...}, "2": {...}, "3": {...}}
      // {...} represent a note. {"title":"blablabla", "text":"",...}
      //following RegExp match the numbers, so we can split the string and get some bunks containing each one a note
      var list = source.split(RegExp("['|\"]\d['|\"][ ]*:"));
      NoteMap map = NoteMap(data: {});
      for (var i = 1; i <= list.length; i++) {
        Note note = Note.fromString(list[i - 1]);
        if (note != null && !note.isEmpty()) map.data[i.toString()] = note;
      }
      return map;
    }
  }
}
