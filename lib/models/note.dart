class Note {
  final String noteId;
  final String title;
  final String text;
  final DateTime editDate;
  final DateTime alarm;
  final bool favorite;
  final bool sticky;

  Note(
      {this.favorite,
      this.sticky,
      this.noteId,
      this.title,
      this.text,
      this.alarm,
      DateTime editDate})
      : this.editDate = editDate ?? DateTime.now();
}
