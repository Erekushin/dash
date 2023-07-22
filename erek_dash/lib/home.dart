import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

import 'package:permission_handler/permission_handler.dart';

import 'controllers/work_with_database.dart';

class DashLanding extends StatefulWidget {
  const DashLanding({super.key});

  @override
  State<DashLanding> createState() => _DashLandingState();
}

class _DashLandingState extends State<DashLanding> {
  final cont = Get.find<WorkLocalCont>();

  final dbHelper = DatabaseHelper();

  void read() async {
    final dataList = await dbHelper.fetchData('my_table');
    dataList.forEach((data) {
      print('ID: ${data['id']}, Name: ${data['name']}, Age: ${data['age']}');
    });
  }

  void update() async {
    final updatedData = {'id': 1, 'name': 'Updated John', 'age': 28};
    await dbHelper.updateData('my_table', updatedData);
  }

  void reaAfterUpdate() async {
    final updatedDataList = await dbHelper.fetchData('my_table');
    updatedDataList.forEach((data) {
      print('ID: ${data['id']}, Name: ${data['name']}, Age: ${data['age']}');
    });
  }

  void delete() async {
    await dbHelper.deleteData('my_table', 1);
  }

  void readAfterdeleter() async {
    final newDataList = await dbHelper.fetchData('my_table');
    newDataList.forEach((data) {
      print('ID: ${data['id']}, Name: ${data['name']}, Age: ${data['age']}');
    });
  }

  Future<String> getExternalDirectoryPath() async {
    if (await Permission.storage.request().isGranted) {
      const directory = "storage/emulated/0/Documents/erekdash_data";
      return directory;
    } else {
      throw Exception('Permission denied');
    }
  }

  Future<void> writeToFile(String data) async {
    final directoryPath = await getExternalDirectoryPath();
    final customDirectoryPath = '$directoryPath/';

    // Create the custom directory if it doesn't exist
    Directory customDirectory = Directory(customDirectoryPath);
    if (!customDirectory.existsSync()) {
      customDirectory.createSync(recursive: true);
    }

    // Write data to the file
    final file = File('$customDirectoryPath/ideaGate.json');
    await file.writeAsString(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Erek dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: 3,
                  itemBuilder: (c, i) {
                    return Container(
                      width: 100,
                      height: 100,
                      color: Colors.red,
                      margin: const EdgeInsets.all(10),
                    );
                  }),
            ),
            const Divider(),
            Expanded(
              flex: 3,
              child: ListView.builder(
                  itemCount: 4,
                  shrinkWrap: true,
                  itemBuilder: (c, i) {
                    return Container(
                      width: 300,
                      height: 50,
                      color: Colors.green,
                      margin: const EdgeInsets.all(10),
                    );
                  }),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  // Row(
                  //   children: [
                  //     Column(
                  //       children: [
                  //         Container(
                  //           width: 200,
                  //           height: 50,
                  //           margin: EdgeInsets.all(10),
                  //           color: Colors.amber,
                  //         ),
                  //         Container(
                  //           width: 200,
                  //           height: 50,
                  //           margin: EdgeInsets.all(10),
                  //           color: Colors.amber,
                  //         )
                  //       ],
                  //     ),
                  //     Column(
                  //       children: [],
                  //     ),
                  //     Container(
                  //       child: Column(
                  //         children: [
                  //           Expanded(child: Container()),
                  //           Expanded(child: Container())
                  //         ],
                  //       ),
                  //     )
                  //   ],
                  // ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Text(
                      'write here ...',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// const TextField(
//                       decoration: InputDecoration(border: InputBorder.none),
//                     )

class DatabaseHelper {
  static Database? _database;

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

  Future<bool> databaseFileExists(String dbPath) async {
    return File(dbPath).exists();
  }

  // Create operation
  Future<int> insertData(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(table, data);
  }
  //"/data/user/0/com.erek_dash/databases/storage/emulated/0/Documents/erekdash_data/dash2.db"

  // Read operation
  Future<List<Map<String, dynamic>>> fetchData(String table) async {
    final db = await database;
    return await db.query(table);
  }

  // Update operation
  Future<int> updateData(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update(
      table,
      data,
      where: 'id = ?',
      whereArgs: [data['id']],
    );
  }

  // Delete operation
  Future<int> deleteData(String table, int id) async {
    final db = await database;
    return await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
