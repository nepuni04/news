import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../models/item_model.dart';
import 'repository.dart';

class NewsDbProvider implements Source, Cache {
  static final NewsDbProvider _instance = NewsDbProvider._internal();
  static Database _db;

  factory NewsDbProvider() => _instance;

  NewsDbProvider._internal();

  Future<Database> initDb() async {
    final Directory docsDirectory = await getApplicationDocumentsDirectory();
    final path = join(docsDirectory.path, "items.db");

    Database db = await openDatabase(path, version: 1,
        onCreate: (Database newDb, int version) async {
      await newDb.execute("""
          CREATE TABLE items(
            id INTEGER PRIMARY KEY,
            deleted INTEGER,
            type TEXT,
            by TEXT,
            time INTEGER,
            text Text,
            dead INTEGER,
            parent INTEGER,
            kids BLOB,
            url TEXT,
            score INTEGER,
            title TEXT,
            descendants INTEGER
          )
        """);
    });
    return db;
  }

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  @override
  Future<ItemModel> fetchItem(int id) async {
    Database dbClient = await db;
    final results =
        await dbClient.query("items", where: "id=?", whereArgs: [id]);

    if (results.length > 0) {
      return ItemModel.fromDb(results.first);
    }
    return null;
  }

  @override
  Future<List<int>> fetchTopIds() {
    return null;
  }

  @override
  Future<int> addItem(ItemModel item) async {
    Database dbClient = await db;
    int res =  await dbClient.insert(
      "items",
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    return res;
  }

  @override
  Future<int> clear() async {
    Database dbClient = await db;
    return await dbClient.delete("items");
  }

  closeDb() async {
    Database dbClient = await db;
    dbClient.close();
  }
}
