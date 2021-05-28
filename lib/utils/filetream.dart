import 'dart:io';
import 'package:path_provider/path_provider.dart';

/*
 * Using path_provider package for finding commonly used locations on the filesystem. 
 * Supports iOS, Android, Linux and MacOS.
 * Use getTemporaryDirectory(); for temp directory and
 * use getApplicationDocumentsDirectory(); for the app directory
 * 
 * Using the class Stream method snapshots, can get file content each time its modified 
 */

class FileStream {
  String fileName;
  String _fileContent;

  FileStream({this.fileName});

  Future<String> get _localPath async {
    final appDocDir = await getApplicationDocumentsDirectory();
    return appDocDir.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    final file = File('$path/' + fileName);
    final exist = await file.exists();
    if (!exist) await file.create();
    return file;
  }

  Future<String> get fileContent async {
    final file = await _localFile;
    return await file.readAsString();
  }

  write(String contents) async {
    final file = await _localFile;
    await file.writeAsString(contents);
  }

  Stream<String> snapshots() async* {
    while (true) {
      final contents = await fileContent;
      if (_fileContent == null || contents != _fileContent) {
        _fileContent = contents;
        yield contents;
      }
    }
  }
}
