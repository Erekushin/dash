import 'package:erek_dash/widgets/snacks.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../globals.dart';

class ProductivityCont extends GetxController {
  String path = '';

  RxList allProductivity = [].obs;
  List entryNames = [];
  List<bool> expandedbool = <bool>[];
  Future getAllDay() async {
    allProductivity.clear();
    List data = [];

    expandedbool.clear();
    try {
      DatabaseEvent a =
          await StaticHelpers.databaseReference.child(path).once();
      if (a.snapshot.exists) {
        Map<dynamic, dynamic> data0 = a.snapshot.value as Map<dynamic, dynamic>;
        data = data0.values.toList();
        entryNames = data0.keys.toList();
      } else {
        allProductivity.clear();
        entryNames.clear();
      }

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
  Future getCurrentDay(String theday) async {
    try {
      Query b = StaticHelpers.databaseReference
          .child(path)
          .orderByChild('created_time')
          .equalTo(theday);
      DatabaseEvent a = await b.once();
      if (a.snapshot.exists) {
        Map<dynamic, dynamic> data = a.snapshot.value as Map<dynamic, dynamic>;
        dayProductivity.value = data.values.toList();
        entryNames = data.keys.toList();
      } else {
        dayProductivity.clear();
        entryNames.clear();
      }
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  Map<String, dynamic> productivityValues() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['note'] = oneHourNote.text;
    data['created_time'] = GlobalValues.nowStrShort;
    return data;
  }

  TextEditingController oneHourNote = TextEditingController();
  insertProductivity() async {
    try {
      if (oneHourNote.text.isNotEmpty) {
        StaticHelpers.databaseReference
            .child('$path/${StaticHelpers.id}')
            .set(productivityValues())
            .whenComplete(() {
          oneHourNote.clear();
          getCurrentDay(GlobalValues.nowStrShort);
        });
      }
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  updateProductivity(String id) async {
    try {
      if (oneHourNote.text.isNotEmpty) {
        StaticHelpers.databaseReference
            .child('$path/$id')
            .set(productivityValues())
            .whenComplete(() {
          oneHourNote.clear();
          getAllDay();
        });
      }
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  deleteProductivity(String id) async {
    try {
      StaticHelpers.databaseReference.child('$path/$id').remove().then((_) {
        getAllDay();
        getCurrentDay(GlobalValues.nowStrShort);
      });
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }
}
