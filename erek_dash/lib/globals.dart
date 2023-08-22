import 'dart:io';
import 'dart:ui';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';

enum HomeScreenType { allTasks, boxTasks, packagedHabits }

class Sizes {
  static double gWidth = Get.width;
  static double gHeight = Get.height;
}

class MyColors {
  static Color mainColor = const Color.fromARGB(255, 67, 67, 67);
}

class GlobalStatics {
  static List habitType = [
    {"id": 1, "name": "morning", 'upperthat': 5, "downerthat": 7},
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
    if (_database != null) {
      if (_database!.isOpen) {
        return _database!;
      }
    }
    String path = await GlobalValues.externalPath;
    _database ??= await openDatabase(
      '$path/data_bases/dash.db',
      version: 1,
      onCreate: (db, version) async {},
    );
    print('object');
    return _database!;
  }

  static Future<void> closeDatabase() async {
    if (_database != null && _database!.isOpen) {
      await _database!.close();
    }
  }
}

class GlobalValues {
  static HomeScreenType homeScreenType = HomeScreenType.allTasks;
  static final DateTime _now = DateTime.now();
  static String get nowStr => _now.toString();
  static String get nowStrShort => _now.toString().substring(0, 10);
  static int? movingIncomingIdeaId;

  //external path that used for database path and image path
  static String _externalPath = '';
  static Future<String> get externalPath async {
    if (_externalPath.isEmpty) {
      final directory = await getExternalStorageDirectory();
      _externalPath = directory!.path;
    }
    return _externalPath;
  }

  // Images path that stores images
  static String? _imageFolderPath;
  static Future<String> get imageFolderPath async {
    String external = await externalPath;
    String path = '$external/images/';
    bool itExists = await Directory(path).exists();
    if (!itExists) {
      await Directory('$external/images/').create(recursive: true);
    }
    _imageFolderPath = '$external/images';
    return _imageFolderPath!;
  }
}
