import 'dart:convert';

import 'package:erek_dash/globals.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helpers/time.dart';
import '../models/task_model.dart';
import '../widgets/snacks.dart';

class TaskCont extends GetxController {
  TimeHelper timeHelper = TimeHelper();
  Task task = Task();
  String tableName = 'tasks';

  var taskListBody = TaskListBody(taskList: []).obs;
  Future<dynamic> getAll() async {
    try {
      final db = await Erekdatabase.database;
      var data = await db.query(tableName, where: 'active = 1 AND done_it = 0');

      taskListBody.value = TaskListBody.fromJson(data);

      // давталтаар нэг бүрчлэн бодоод үлдсэн хугацаа зарцуулагдах хугацааг нь тооцсон
      for (int i = 0; i < taskListBody.value.taskList.length; i++) {
        var item = taskListBody.value.taskList[i];
        int timeValue = item.importancy!;
        int remainingHour = timeHelper.calculateHoursDifference(
            GlobalValues.nowStr, item.pinnedTime!);
        int remainingValue = remainingHour ~/ item.spendingTime!;
        if (remainingValue >= 9) {
          timeValue = timeValue + 1;
        } else {
          switch (remainingValue) {
            case 8:
              timeValue = timeValue + 2;
              break;
            case 7:
              timeValue = timeValue + 3;
              break;
            case 6:
              timeValue = timeValue + 4;
              break;
            case 5:
              timeValue = timeValue + 5;
              break;
            case 4:
              timeValue = timeValue + 6;
              break;
            case 3:
              timeValue = timeValue + 7;
              break;
            case 2:
              timeValue = timeValue + 8;
              break;
            case 1:
              timeValue = timeValue + 9;
              break;
            default:
          }
        }
        taskListBody.value.taskList[i].timeValue = timeValue;
        taskListBody.value.taskList[i].remaininghours = remainingHour;
      }

      taskListBody.value.taskList
          .sort((a, b) => b.timeValue!.compareTo(a.timeValue!));
    } catch (e) {
      Snacks.errorSnack(e);
    }
    // print(const JsonEncoder.withIndent('  ').convert(taskList[0]));
  }

  RxList completedList = [].obs;
  Future getAllCompleted() async {
    try {
      final db = await Erekdatabase.database;
      completedList.value = await db.query(tableName, where: 'done_it = 1');
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  TextEditingController txtCnt = TextEditingController();
  TextEditingController importancy = TextEditingController();
  TextEditingController startingDate = TextEditingController();
  TextEditingController pinnedDate = TextEditingController();
  TextEditingController startingTime = TextEditingController();
  TextEditingController pinnedTime = TextEditingController();
  Future insertTask() async {
    if (txtCnt.text.isNotEmpty &&
        startingDate.text.isNotEmpty &&
        pinnedDate.text.isNotEmpty &&
        importancy.text.isNotEmpty) {
      try {
        int? numericValue = int.tryParse(importancy.text);
        if (numericValue == null) {
          throw Exception('importancy should be number');
        }
        int speningHours = timeHelper.calculateHoursDifference(
            '${startingDate.text} ${startingTime.text}:00.000',
            '${pinnedDate.text} ${pinnedTime.text}:00.000');
        if (speningHours < 0) {
          throw Exception('spending time is in valid');
        }
        final db = await Erekdatabase.database;
        await db.insert(tableName, {
          'task': txtCnt.text,
          'created_time': GlobalValues.nowStr,
          'updated_time': GlobalValues.nowStr,
          'starting_time': '${startingDate.text} ${startingTime.text}:00.000',
          'pinned_time': '${pinnedDate.text} ${pinnedTime.text}:00.000',
          'importancy': importancy.text,
          'spending_time': speningHours,
          'active': 1,
          'done_it': 0
        });
        txtCnt.clear();
        startingDate.clear();
        pinnedDate.clear();
        startingTime.clear();
        pinnedTime.clear();
        importancy.clear();
        Snacks.savedSnack();
      } catch (e) {
        Snacks.errorSnack(e);
      }
    }
    getAll();
  }

  TextEditingController editCnt = TextEditingController();
  TextEditingController editimportancy = TextEditingController();
  TextEditingController editstartingDate = TextEditingController();
  TextEditingController editpinnedDate = TextEditingController();
  TextEditingController editstartingTime = TextEditingController();
  TextEditingController editpinnedTime = TextEditingController();
  Future updateTask(int id, Map<String, dynamic> data) async {
    editCnt.text = editCnt.text.trimRight();
    final db = await Erekdatabase.database;
    db.update(
      tableName,
      data,
      where: 'id = $id',
    );
    getAll();
    Get.back();
    Snacks.updatedSnack();
  }

  Future deleteTask(int id) async {
    final db = await Erekdatabase.database;
    db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    getAll();
  }
}
