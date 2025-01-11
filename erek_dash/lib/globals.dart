import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';

enum MiddleScreenType {
  allTasks,
  outerTasks,
  nowTasks,
  boxTasks,
  packagedHabits
}

class Sizes {
  static double gWidth = Get.width;
  static double gHeight = Get.height;
}

class MyColors {
  static Color mainColor = const Color.fromARGB(255, 67, 67, 67);
}

class GlobalStatics {
  // static List habitType = [
  //   {"id": 1, "name": "morning", 'upperthat': 5, "downerthat": 7},
  //   {"id": 2, "name": "evening", 'upperthat': 18, "downerthat": 22},
  // ];

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

class StaticHelpers {
  static User? userInfo;
  static bool darkMode = false;
  static final DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref();

  static String _id = '';
  static String get id {
    DateTime now = DateTime.now();
    final int random = Random().nextInt(10);
    _id =
        "${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}$random";
    return _id;
  }
}

class GlobalValues {
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
}
