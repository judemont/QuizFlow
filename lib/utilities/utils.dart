import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:quizflow/models/voc.dart';
import 'package:quizflow/utilities/database.dart';

import 'package:share_plus/share_plus.dart';

class Utils {
  static const Encoding _textFileEncoding = utf8;

  static Future<void> userExportVoc(Voc voc) async {
    Directory directory = await getTemporaryDirectory();
    String appDocumentsPath = directory.path;
    String filePath = '$appDocumentsPath/quizflow_list_${voc.id}.json';

    File file = File(filePath);

    String result = await DatabaseService.exportVoc(voc);
    var fileBytes = _textFileEncoding.encode(result);
    await file.writeAsBytes(fileBytes);
    await Share.shareXFiles([XFile(filePath)]);
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
