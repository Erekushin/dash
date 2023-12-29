import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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
  static LinearGradient helperPink = const LinearGradient(colors: [
     Color.fromARGB(255, 57, 19, 161),
    Colors.black,
  ]);
}

class GlobalStatics {
  static List mainFunctionalities = [
    {"id": 0, "name": "incoming"},
    {"id": 1, "name": "note"},
    {"id": 2, "name": "task"},
    {"id": 3, "name": "habit"},
  ];
}

class StaticHelpers {
  static RxString homeMiddleAreaType = 'allTasks'.obs;
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
