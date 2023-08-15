import 'package:erek_dash/globals.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/snacks.dart';

class IdeaCont extends GetxController {
  String tableName = 'newIdeas';

  RxList interestingIdeaList = [].obs;
  Future allIdeas() async {
    try {
      final db = await Erekdatabase.database;
      interestingIdeaList.value = await db.query(tableName);
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  TextEditingController ideaTxt = TextEditingController();
  insertIdea() async {
    try {
      final db = await Erekdatabase.database;
      if (ideaTxt.text.isNotEmpty) {
        db.insert(tableName, {
          'idea': ideaTxt.text,
          'created_time': GlobalValues.nowStrShort,
          'updated_time': GlobalValues.nowStr
        });
        allIdeas();
        ideaTxt.clear();
      }
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  TextEditingController updateTxt = TextEditingController();
  updateIdea(int id) async {
    try {
      final db = await Erekdatabase.database;
      db.update(tableName,
          {'idea': updateTxt.text, 'updated_time': GlobalValues.nowStr},
          where: 'id = $id');
      allIdeas();
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  deleteIdea(int id) async {
    try {
      final db = await Erekdatabase.database;
      db.delete(tableName, where: 'id = $id');
      allIdeas();
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }
}
