import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../globals.dart';
import '../idea_stream/idea_stream_cont.dart';
import '../widgets/snacks.dart';

class NoteCont extends GetxController {
  final ideaCont = Get.find<IdeaStreamCont>();
  RxList notes = [].obs;
  List<bool> expandedbool = <bool>[];
  String tableName = 'notes';
  Future getAll() async {
    try {
      final db = await Erekdatabase.database;
      notes.value = await db.query(tableName);
      for (int i = 0; i < notes.length; i++) {
        expandedbool.add(false);
      }
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  RxList today = [].obs;
  Future getToday() async {
    try {
      final db = await Erekdatabase.database;
      today.value = await db.query(tableName,
          where: 'created_time = ?', whereArgs: [GlobalValues.nowStrShort]);
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  TextEditingController notetxt = TextEditingController();
  TextEditingController noteTitle = TextEditingController();
  Future insertNote(bool movingIn) async {
    if (notetxt.text.isNotEmpty) {
      try {
        final db = await Erekdatabase.database;
        db.insert(tableName, {
          'note': notetxt.text,
          'title': noteTitle.text,
          'created_time': GlobalValues.nowStrShort
        });
        Snacks.savedSnack();
        notetxt.clear();
        noteTitle.clear();
        if (movingIn) {
          ideaCont.deleteIdea(GlobalValues.movingIncomingIdeaId!);
        }
        getAll();
      } catch (e) {
        Snacks.errorSnack(e);
      }
    }
  }

  Future deleteNote(int id) async {
    try {
      final db = await Erekdatabase.database;
      db.delete(tableName, where: 'id = ?', whereArgs: [id]);
      getAll();
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }
}
