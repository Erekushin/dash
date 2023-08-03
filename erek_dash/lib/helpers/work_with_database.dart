import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '../widgets/snacks.dart';

class WorkLocal {
  //initialize database
  static Database? _database;

  //open database
  Future<Database> get database async {
    final directory = await getExternalStorageDirectory();
    final externalStoragePath = directory!.path;
    if (_database != null) {
      return _database!;
    }
    return await openDatabase(
      '$externalStoragePath/data_bases/dash.db',
      version: 1,
      onCreate: (db, version) async {},
    );
  }

  // create data
  Future<bool> insertData(String table, Map<String, dynamic> data) async {
    try {
      final db = await database;
      await db.insert(table, data);
      Snacks.savedSnack();
      return true;
    } catch (e) {
      Snacks.errorSnack(e);
      return false;
    }
  }

  // Read operation
  Future<List<Map<String, dynamic>>> fetchData(String table) async {
    final db = await database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> fetchFilteredData(
      String table, String whereKey1, int whereArg1) async {
    final db = await database;
    return await db.query(
      table,
      where: '$whereKey1 = ?',
      whereArgs: [whereArg1],
    );
  }

  Future<List<Map<String, dynamic>>> fetchTwoFilteredData(
      String table,
      String whereKey1,
      int whereArg1,
      String whereKey2,
      String whereArg2) async {
    final db = await database;
    return await db.query(
      table,
      where: '$whereKey1 = ? AND $whereKey2 = ?',
      whereArgs: [whereArg1, whereArg2],
    );
  }

  // Update operation
  Future<bool> updateData(
      String table, int id, Map<String, dynamic> data) async {
    try {
      final db = await database;
      db.update(
        table,
        data,
        where: 'id = $id',
        whereArgs: [],
      );
      return true;
    } catch (e) {
      Snacks.errorSnack(e);
      return false;
    }
  }

  // Delete operation
  Future<bool> deleteData(String table, String whereKey, int id) async {
    try {
      final db = await database;
      await db.delete(
        table,
        where: '$whereKey = ?',
        whereArgs: [id],
      );
      return true;
    } catch (e) {
      Snacks.errorSnack(e);
      return false;
    }
  }
}
