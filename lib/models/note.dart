class Note {
  String id;
  String title;
  String text;
  bool favorite;
  DateTime editDate;

  Note({
    this.id,
    this.title = '',
    this.text = '',
    this.favorite = false,
    DateTime editDate,
  }) : this.editDate = editDate ?? DateTime.now();

  Note.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        text = map['text'],
        favorite = map['favorite'] != 0,
        editDate = DateTime.parse(map['editDate']);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'text': text,
      'favorite': favorite,
      'editDate': editDate.toString(),
    };
  }
}
