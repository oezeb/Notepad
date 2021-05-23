class Note {
  final String noteId;
  String title;
  String text;
  bool favorite;
  DateTime editDate;

  Note(this.noteId,
      {this.title = "",
      this.text = "",
      this.favorite = false,
      DateTime editDate})
      : this.editDate = editDate ?? DateTime.now();
}
