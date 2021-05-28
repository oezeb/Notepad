import 'dart:convert';

class Note {
  String title;
  String text;
  bool favorite;
  DateTime editDate;

  Note({
    this.title = '',
    this.text = '',
    this.favorite = false,
    DateTime editDate,
  }) : this.editDate = editDate ?? DateTime.now();

  Note.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        text = json['text'],
        favorite = json['favorite'],
        editDate = DateTime.parse(json['editDate']);

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'text': text,
      'favorite': favorite,
      'editDate': editDate.toString(),
    };
  }

  isEmpty() => title == '' && text == '';

  static Note fromString(String source) {
    try {
      // trying to use the built in function to parse Json
      return Note.fromJson(json.decode(source));
    } catch (err) {
      if (source == null || source == '') {
        // it's empty
        return null;
      } else {
        // trying to repair the string in order to get a least one Note out of it
        // first try to add brackets if ther isn't
        bool hasLeftBracket = source[0] == '{';
        bool hasRightBracket = source[source.length - 1] == '}';
        if (!hasRightBracket || !hasRightBracket) {
          if (!hasLeftBracket) source = '{' + source;
          if (!hasRightBracket) source += '}';
          return fromString(source);
        } else {
          // if it still doesn't work find maybe inside the given string a substring enclose with brakets
          return fromString(RegExp('{.*}').stringMatch(source.substring(1)));
        }
      }
    }
  }
}
