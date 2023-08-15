import 'package:erek_dash/widgets/snacks.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../globals.dart';

class ProductivityCont extends GetxController {
  String tableName = 'productivityduration';

  RxList allProductivity = [].obs;

  List<bool> expandedbool = <bool>[];
  Future getAllDay() async {
    allProductivity.clear();

    expandedbool.clear();
    try {
      final db = await Erekdatabase.database;
      List data = await db.query(tableName);

      List littleList = [];
      String thatDate = '';
      for (int i = 0; i < data.length; i++) {
        var item = data[i];
        if (i == 0) {
          thatDate = item['created_time'];
          littleList.add(item);
          if (data.length == 1) {
            Map<String, dynamic> unit = {};
            unit['created_time'] = thatDate;
            unit['items'] = littleList.toList();
            allProductivity.add(unit);
            expandedbool.add(false);
            littleList.clear();
            thatDate = '';
          }
        } else {
          if (item['created_time'] == thatDate) {
            littleList.add(item);
            if (i == (data.length - 1)) {
              Map<String, dynamic> unit = {};
              unit['created_time'] = thatDate;
              unit['items'] = littleList.toList();
              allProductivity.add(unit);
              expandedbool.add(false);
              littleList.clear();
              thatDate = '';
            }
          } else {
            Map<String, dynamic> unit = {};
            unit['created_time'] = thatDate;
            unit['items'] = littleList.toList();
            allProductivity.add(unit);
            expandedbool.add(false);
            littleList.clear();
            thatDate = '';
            thatDate = item['created_time'];
            littleList.add(item);

            if (i == (data.length - 1)) {
              Map<String, dynamic> unit = {};
              unit['created_time'] = thatDate;
              unit['items'] = littleList.toList();
              allProductivity.add(unit);
              expandedbool.add(false);
              littleList.clear();
              thatDate = '';
            }
          }
        }
      }
    } catch (e) {
      Snacks.errorSnack(e);
      print(e.toString());
    }
  }

  RxList dayProductivity = [].obs;
  Future getCurrentDay() async {
    try {
      final db = await Erekdatabase.database;
      dayProductivity.value = await db.query(tableName,
          where: 'created_time = ?', whereArgs: [GlobalValues.nowStrShort]);
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  TextEditingController oneHourNote = TextEditingController();
  insertProductivity() async {
    try {
      final db = await Erekdatabase.database;
      if (oneHourNote.text.isNotEmpty) {
        await db.insert(tableName, {
          'created_time': GlobalValues.nowStrShort,
          'note': oneHourNote.text
        });
        oneHourNote.clear();
        getCurrentDay();
      }
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  TextEditingController editTxt = TextEditingController();
  updateProductivity(int id) async {
    try {
      final db = await Erekdatabase.database;
      db.update(tableName, {'note': editTxt.text}, where: 'id = $id');
      getAllDay();
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  deleteProductivity(int id) async {
    try {
      final db = await Erekdatabase.database;
      db.delete(tableName, where: 'id = $id');
      getAllDay();
      getCurrentDay();
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }
}
