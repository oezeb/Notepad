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

  factory Note.copy(Note other) {
    return Note(
      other.noteId,
      title: other.title,
      text: other.text,
      favorite: other.favorite,
      editDate: other.editDate,
    );
  }

  static Map<String, Note> parseNotes(String text) {
    List<String> bunks = text.split(RegExp("<|><|>"));
    Map<String, Note> map = {};
    String currId = "";
    for (int i = 1; i + 1 < bunks.length; i += 2) {
      switch (bunks[i]) {
        case "noteId":
          currId = bunks[i + 1];
          map[currId] = Note(currId);
          break;
        case "title":
          map[currId].title = bunks[i + 1];
          break;
        case "text":
          map[currId].text = bunks[i + 1];
          break;
        case "favorite":
          map[currId].favorite = bunks[i + 1] == "true";
          break;
        case "editDate":
          map[currId].editDate = DateTime.parse(bunks[i + 1]);
          break;
        default:
      }
    }
    return map;
  }

  @override
  String toString() {
    return "<noteId><$noteId><title><$title><text><$text><favorite><$favorite><editDate><$editDate>";
  }
}
