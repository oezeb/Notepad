class Note {
  final String noteId;
  String title;
  String text;
  DateTime editDate;
  bool favorite;
  bool sticky;

  Note(
      {this.favorite = false,
      this.sticky = false,
      this.noteId = "",
      this.title = "",
      this.text = "",
      DateTime editDate})
      : this.editDate = editDate ?? DateTime.now();
}
