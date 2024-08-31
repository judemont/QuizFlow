import 'dart:convert';
import 'dart:io';

import 'package:flutter_archive/flutter_archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quizflow/models/voc.dart';
import 'package:quizflow/utilities/database.dart';

import 'package:share_plus/share_plus.dart';

class Utils {
  static const Encoding _textFileEncoding = utf8;

  static Future<String> exportAllToFile() async {
    Directory directory = await getTemporaryDirectory();

    List<Voc> vocs = await DatabaseService.getVocs();
    List<File> files = [];
    for (Voc voc in vocs) {
      files.add(await exportVocToFile(voc.id.toString(), voc));
    }

    String zipFilePath =
        '${directory.path}/QuizFlow_Export_${DateTime.now().millisecondsSinceEpoch}.zip';

    File zipFile = File(zipFilePath);
    zipFile.writeAsString("contents");
    ZipFile.createFromFiles(
        sourceDir: files[0].parent, files: files, zipFile: zipFile);

    return zipFilePath;
  }

  static Future<void> userExportAll() async {
    String filePath = await exportAllToFile();
    await Share.shareXFiles([XFile(filePath)]);
  }

  static Future<void> userExportVoc(Voc voc) async {
    String filePath =
        (await exportVocToFile("quizflow_list_${voc.id}.json", voc)).path;
    await Share.shareXFiles([XFile(filePath)]);
  }

  static Future<File> exportVocToFile(String fileName, Voc voc) async {
    Directory directory = await getTemporaryDirectory();
    String appDocumentsPath = directory.path;
    String filePath = '$appDocumentsPath/$fileName';

    File file = File(filePath);

    String result = await DatabaseService.exportVoc(voc);
    var fileBytes = _textFileEncoding.encode(result);
    await file.writeAsBytes(fileBytes);

    return file;
  }

  // static Future<void> userExport() async {
  //   Directory directory = await getTemporaryDirectory();
  //   String appDocumentsPath = directory.path;
  //   String filePath = '$appDocumentsPath/QuizFlow_Export.json';

  //   File file = File(filePath);

  //   DatabaseService db = DatabaseService();
  //   String result = await db.export();
  //   var fileBytes = _textFileEncoding.encode(result);
  //   await file.writeAsBytes(fileBytes);
  //   await Share.shareXFiles([XFile(filePath)]);
  // }

  // static Future<int> userImport() async {
  //   const XTypeGroup typeGroup = XTypeGroup(
  //     label: 'QuizFlow export',
  //     extensions: <String>['json'],
  //   );
  //   final XFile? file =
  //       await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);

  //   if (file != null) {
  //     var fileBytes = await file.readAsBytes();
  //     String backupContent = _textFileEncoding.decode(fileBytes);
  //     DatabaseService db = DatabaseService();
  //     await db.import(backupContent);
  //   }
  //   return 1;
  // }
}
