import 'package:notepad/models/note.dart';

List<Note> allNotes = [n1, n2, n3, n4];
List<Note> favNotes = [n1, n4];

Note n1 = Note(
  noteId: "1",
  title: "accumsan tortor",
  text:
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Vitae tortor condimentum lacinia quis vel.",
  editDate: DateTime(2021, 04, 21),
  sticky: true,
  favorite: true,
);
Note n2 = Note(
  noteId: "2",
  title: "porta",
  text:
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Elementum nibh tellus molestie nunc non blandit. Arcu vitae elementum curabitur vitae. Ullamcorper sit amet risus nullam eget. Nunc consequat interdum varius sit amet mattis. Justo donec enim diam vulputate ut pharetra. Non blandit massa enim nec dui nunc mattis. Duis at tellus at urna condimentum mattis. Interdum velit laoreet id donec ultrices tincidunt arcu non sodales. Eget nullam non nisi est sit. Accumsan sit amet nulla facilisi. A condimentum vitae sapien pellentesque habitant. Elit sed vulputate mi sit amet mauris commodo quis. Et malesuada fames ac turpis egestas. Aliquet lectus proin nibh nisl. Integer feugiat scelerisque varius morbi enim nunc faucibus a pellentesque. Orci ac auctor augue mauris augue neque gravida in. At risus viverra adipiscing at in tellus. Eget sit amet tellus cras.\nNatoque penatibus et magnis dis parturient montes nascetur. Eget nunc lobortis mattis aliquam faucibus purus in massa tempor. Tortor consequat id porta nibh venenatis cras sed. Eu augue ut lectus arcu bibendum at varius vel pharetra. In egestas erat imperdiet sed euismod nisi porta. Fermentum iaculis eu non diam phasellus vestibulum lorem sed. Habitant morbi tristique senectus et. Ac odio tempor orci dapibus ultrices in. Odio pellentesque diam volutpat commodo sed. Id interdum velit laoreet id donec ultrices tincidunt arcu non. Pretium lectus quam id leo in vitae. Molestie a iaculis at erat pellentesque adipiscing commodo elit. Eget lorem dolor sed viverra ipsum nunc aliquet bibendum. Enim sit amet venenatis urna cursus eget nunc scelerisque. Sagittis aliquam malesuada bibendum arcu vitae elementum curabitur vitae nunc.",
  editDate: DateTime(2021, 03, 18),
  sticky: true,
);

Note n3 = Note(
  noteId: "3",
  title: "",
  text:
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Libero volutpat sed cras ornare arcu dui vivamus. Elementum nibh tellus molestie nunc non blandit massa enim nec. Amet commodo nulla facilisi nullam vehicula. Scelerisque mauris pellentesque pulvinar pellentesque.",
  editDate: DateTime(2021, 02, 08),
);

Note n4 = Note(
  noteId: "4",
  title: "Elementum eu",
  text:
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
  editDate: DateTime(2021, 04, 21),
  sticky: false,
  favorite: true,
);
