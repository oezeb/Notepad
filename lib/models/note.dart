class Note {
  final String noteId;
  final String title;
  final String text;
  final DateTime editDate;
  final DateTime alarm;

  Note({this.noteId, this.title, this.text, this.alarm, DateTime editDate})
      : this.editDate = editDate ?? DateTime.now();
}
