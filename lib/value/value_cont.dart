import 'package:erek_dash/globals.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/snacks.dart';

class ValueCont extends GetxController {
  //#region value CRUD ----------------------------------------------------------

  createValue() async {
    try {
      if (txtCnt.text.isNotEmpty) {
        loadingVis.value = true;
        String id = StaticHelpers.id;
        StaticHelpers.databaseReference
            .child('$path/$id')
            .set(valueValues(id))
            .whenComplete(() async {
          readValueList();
          Snacks.savedSnack();
        });
      }
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  readValueList() async {
    try {
      DatabaseEvent a =
          await StaticHelpers.databaseReference.child(path).once();
      if (a.snapshot.exists) {
        Map<dynamic, dynamic> data = a.snapshot.value as Map<dynamic, dynamic>;
        valueHistory.value = data.values.toList();
      } else {
        valueHistory.clear();
      }
    } catch (e) {
      print('error: $e');
    }
  }

  Future deleteValue(String id) async {
    StaticHelpers.databaseReference.child("$path/$id").remove().then((_) {
      readValueList();
      Get.back();
    });
  }

  Map<String, dynamic> valueValues(String id) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['value'] = txtCnt.text;
    data['description'] = descriptionTxt.text;
    data['created_time'] = createdTime.toString().substring(0, 16);
    data['active'] = isActive;
    return data;
  }

  setValues(item) {
    txtCnt.text = item['value'];
    isActive = item['active'];
  }

  //#endregion value CRUD--------------------------------------------------------

  //#region variebles------------------------------------------------------------
  TextEditingController descriptionTxt = TextEditingController();

  TextEditingController txtCnt = TextEditingController();
  bool isActive = true;
  DateTime createdTime = DateTime.now();
  String path = '';
  RxBool loadingVis = false.obs;
  RxList valueHistory = [].obs;

  //#endregion variebles
}
