
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:voclearner/models/voc.dart';
import 'package:voclearner/models/word.dart';

class DatabaseService {
  static const String databaseName = "voclearnerDB.sqlite";
  static Database? db;

  static const databaseVersion = 1;
  List<String> tables = ["Vocs", "Words"];

  static Future<Database> initializeDb() async {
    final databasePath = (await getApplicationDocumentsDirectory()).path;
    final path = join(databasePath, databaseName);
    return db ??
        await openDatabase(
          path,
          version: databaseVersion,
          onCreate: (Database db, int version) async {
            await createTables(db);
          },
          onUpgrade: (db, oldVersion, newVersion) async {
            await updateTables(db, oldVersion, newVersion);
          },
          onOpen: (db) async {
            await openDB(db);
          },
        );
  }

  static openDB(Database db) {
    db.rawQuery('SELECT * FROM sqlite_master ORDER BY name;').then((value) {
      print(value);
    });
  }

  static updateTables(Database db, int oldVersion, int newVersion) {
    print(" DB Version : $newVersion");
    print(oldVersion);
    if (oldVersion < newVersion) {}
  }

  static Future<void> createTables(Database database) async {
    await database.execute("""
      CREATE TABLE Vocs(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          description TEXT
      )
    """);

    await database.execute("""
      CREATE TABLE Words(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          word TEXT,
          definition TEXT,
          vocId INTEGER
      )
    """);
  }

  static Future<int> createVoc(Voc voc) async {
    print("CREATE");

    final db = await DatabaseService.initializeDb();

    final id = await db.insert('Vocs', voc.toMap());
    return id;
  }

  static Future<int> createWord(Word word) async {
    final db = await DatabaseService.initializeDb();

    final id = await db.insert('Words', word.toMap());
    return id;
  }

  static Future<List<Voc>> getVocs({String searchQuery = ""}) async {
    final db = await DatabaseService.initializeDb();

    List<Map<String, dynamic>> queryResult =
        await db.query('Vocs', where: "title LIKE '%$searchQuery%'");

    return queryResult.map((e) => Voc.fromMap(e)).toList();
  }

  static Future<List<Word>> getWord() async {
    final db = await DatabaseService.initializeDb();

    List<Map<String, dynamic>> queryResult = await db.query('Words');

    return queryResult.map((e) => Word.fromMap(e)).toList();
  }

  static Future<List<Word>> getWordsFromVoc(int vocId) async {
    final db = await DatabaseService.initializeDb();

    List<Map<String, dynamic>> vocWords =
        await db.query('Words', where: "vocId = $vocId");

    return vocWords.map((e) => Word.fromMap(e)).toList();
  }

  static Future<void> removeVoc(int vocId) async {
    final db = await DatabaseService.initializeDb();
    db.delete("Vocs", where: "id = $vocId");
    db.delete("Words", where: "vocId = $vocId");
  }

  static Future<void> removeWord(int wordId) async {
    final db = await DatabaseService.initializeDb();
    db.delete("Words", where: "id = $wordId");
  }

  static Future<void> updateVoc(Voc voc) async {
    final db = await DatabaseService.initializeDb();
    db.update("Vocs", voc.toMap(), where: 'id = ?', whereArgs: [voc.id]);
  }

  static Future<void> updateWord(Word word) async {
    print("UPDATE");

    final db = await DatabaseService.initializeDb();

    db.update("Words", word.toMap(), where: 'id = ?', whereArgs: [word.id]);
  }

  // Future<String> export({bool isEncrypted = false}) async {
  //   print('GENERATE BACKUP');

  //   var dbs = await DatabaseService.initializeDb();

  //   List data = [];

  //   List<Map<String, dynamic>> listMaps = [];

  //   for (var i = 0; i < tables.length; i++) {
  //     listMaps = await dbs.query(tables[i]);

  //     data.add(listMaps);
  //   }

  //   List backups = [tables, data];

  //   String jsonData = jsonEncode(backups);
  //   print(jsonData);
  //   return jsonData;
  // }

  // Future<void> import(String backup) async {
  //   print(backup);
  //   var dbs = await DatabaseService.initializeDb();

  //   Batch batch = dbs.batch();

  //   List jsonData = jsonDecode(backup);
  //   print(jsonData);
  //   List<Recipe> actualRecipes = await DatabaseService.getRecipes();

  //   for (var i = 0; i < jsonData[0].length; i++) {
  //     for (var k = 0; k < jsonData[1][i].length; k++) {
  //       if (actualRecipes
  //           .where((recipe) => recipe.title == jsonData[1][i][k]["title"])
  //           .isEmpty) {
  //         jsonData[1][i][k]["id"] = null;
  //         batch.insert(jsonData[0][i], jsonData[1][i][k]);
  //       }
  //     }
  //   }

  //   await batch.commit(continueOnError: false, noResult: true);

  //   print('RESTORE BACKUP');
  // }
}
