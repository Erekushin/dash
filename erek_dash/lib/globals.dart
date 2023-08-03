import 'dart:ui';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';

class Sizes {
  static double gWidth = Get.width;
  static double gHeight = Get.height;
}

class MyColors {
  static Color mainColor = const Color.fromARGB(255, 67, 67, 67);
}

class GlobalStatics {
  static List habitType = [
    {"id": 0, "name": "noType", 'upperthat': 0, "downerthat": 0},
    {"id": 1, "name": "morning", 'upperthat': 5, "downerthat": 10},
    {"id": 2, "name": "evening", 'upperthat': 18, "downerthat": 22},
  ];

  static List mainFunctionalities = [
    {"id": 0, "name": "incoming"},
    {"id": 1, "name": "note"},
    {"id": 2, "name": "task"},
    {"id": 3, "name": "habit"},
  ];
}

class Erekdatabase {
  //initialize database
  static Database? _database;

  //open database
  static Future<Database> get database async {
    final directory = await getExternalStorageDirectory();
    final externalStoragePath = directory!.path;
    _database ??= await openDatabase(
      '$externalStoragePath/data_bases/dash.db',
      version: 1,
      onCreate: (db, version) async {},
    );
    return _database!;
  }
}

class GlobalValues {
  static final DateTime _now = DateTime.now();
  static String get nowStr => _now.toString();
  static int? movingIncomingIdeaId;
}
