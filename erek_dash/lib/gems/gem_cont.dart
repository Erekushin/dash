import 'package:erek_dash/globals.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/snacks.dart';

class GemCont extends GetxController {
  String tableName = 'gems';

  RxList gemList = [].obs;
  Future allGems() async {
    try {
      final db = await Erekdatabase.database;
      gemList.value = await db.query(tableName);
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  TextEditingController gemTxt = TextEditingController();
  insertGem() async {
    try {
      final db = await Erekdatabase.database;
      if (gemTxt.text.isNotEmpty) {
        db.insert(tableName, {
          'gem': gemTxt.text,
          'created_time': GlobalValues.nowStrShort,
          'updated_time': GlobalValues.nowStr
        });
        allGems();
        gemTxt.clear();
      }
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  TextEditingController updateTxt = TextEditingController();
  updateGem(int id) async {
    try {
      final db = await Erekdatabase.database;
      db.update(tableName,
          {'gem': updateTxt.text, 'updated_time': GlobalValues.nowStr},
          where: 'id = $id');
      allGems();
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  deleteGem(int id) async {
    try {
      final db = await Erekdatabase.database;
      db.delete(tableName, where: 'id = $id');
      allGems();
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }
}
