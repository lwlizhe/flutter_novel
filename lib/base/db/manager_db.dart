import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import 'package:meta/meta.dart';

class DBManager {
  static const _VERSION = 1;
  static const _DB_NAME = "flutter_novel.db";
  Database _db;
  final _lock = Lock();

  factory DBManager() => _getInstance();

  static DBManager get instance => _getInstance();
  static DBManager _instance;

  DBManager._internal();

  static DBManager _getInstance() {
    if (_instance == null) {
      _instance = new DBManager._internal();
    }
    return _instance;
  }

  Future<void> init() async {
    // DB path
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _DB_NAME);
    if (!await Directory(dirname(path)).exists()) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (e) {
        print(e);
      }
    }
    _db = await openDatabase(path,
        version: _VERSION, onCreate: (Database db, int version) async {});
  }

  Future<bool> isTableExits(String tableName) async {
    await getDB();
    var res = await _db.rawQuery(
        "select * from Sqlite_master where type = 'table' and name = '$tableName'");
    return res != null && res.isNotEmpty;
  }

  Future<Database> getDB() async {
    if (_db == null) {
      await _lock.synchronized(() async {
        // Check again once entering the synchronized block
        if (_db == null) {
          await init();
        }
      });
    }
    return _db;
  }

  void close() {
    _db?.close();
    _db = null;
  }
}

/// Base provider
abstract class BaseDBProvider {
  bool isTableExits = false;

  String createSql();

  String tableName();

  String baseCreateSql(String name, String columnId) {
    return '''
        create table $name (
        $columnId integer primary key autoincrement,
      ''';
  }

  @mustCallSuper
  Future<void> createTable(String name, String createSql) async {
    isTableExits = await DBManager.instance.isTableExits(name);
    if (!isTableExits) {
      Database db = await DBManager.instance.getDB();
      return await db.execute(createSql);
    }
  }

  @mustCallSuper
  Future<Database> getDB() async {
    await createTable(tableName(), createSql());
    return await DBManager.instance.getDB();
  }
}