import 'package:erek_dash/globals.dart';
import 'package:erek_dash/tasks/task_cont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/snacks.dart';

class BoxCont extends GetxController {
  String tableName = 'boxes';

  RxList boxList = [].obs;
  Future allBoxes() async {
    try {
      final db = await Erekdatabase.database;
      boxList.value = await db.query(tableName);
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  TextEditingController boxNameTxt = TextEditingController();
  TextEditingController discripctionTxt = TextEditingController();
  insertBox(String path) async {
    try {
      final db = await Erekdatabase.database;
      if (boxNameTxt.text.isNotEmpty) {
        db.insert(tableName, {
          'boxname': boxNameTxt.text,
          'discription': discripctionTxt.text,
          'picture': path,
          'created_time': GlobalValues.nowStrShort,
          'updated_time': GlobalValues.nowStr
        });
        allBoxes();
        boxNameTxt.clear();
        discripctionTxt.clear();
      }
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  TextEditingController updateTxt = TextEditingController();
  updateBox(int id) async {
    try {
      final db = await Erekdatabase.database;
      db.update(tableName,
          {'boxname': updateTxt.text, 'updated_time': GlobalValues.nowStr},
          where: 'id = $id');
      allBoxes();
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  deleteBox(int id) async {
    try {
      final db = await Erekdatabase.database;
      db.delete(tableName, where: 'id = $id');
      allBoxes();
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }
}
