import 'package:notepad/models/note.dart';

List<Note> notes = [
  Note(
    noteId: "1",
    title: "Huffman Compression",
    text:
        "Decription : Implement a program that can compress and decompress files.\nProgramming language: C++\nIn order to realise this project we used Huffman Coding.\n Compression: \n    - Count the frequency of each CHAR in the input file.\n     - Build the Huffman Tree.\n    - Save the Tree details into output file.\n    - Encode the file using the Tree.\nDecompression:\n    - Read out Huffman tree\n    - Decode file using the tree\nOthers features:\n    - use commands to compress and decompress files :\n        App -z hello.txt   //compress hello.txt file\n        App -u hello.txt.huff //decompress file\n",
    editDate: DateTime(2021, 02, 08),
  ),
  Note(
    noteId: "2",
    title: "Dayana Finance",
    text:
        "1. Deposit 98 Pack 23 days(10/2/2021-5/3/2021) Rate 130%\n2. Deposit 98 Pack 23 days(6/3/2021-28/3/2021) Rate 130%\n",
    editDate: DateTime(2021, 03, 18),
  ),
  Note(
    noteId: "3",
    title: "",
    text: "斗破苍穹",
    editDate: DateTime(2021, 04, 21),
  ),
];
