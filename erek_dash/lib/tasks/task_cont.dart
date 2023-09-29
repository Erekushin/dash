import 'dart:math';

import 'package:erek_dash/globals.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helpers/time.dart';
import '../idea_stream/idea_stream_cont.dart';
import '../widgets/snacks.dart';

class TaskCont extends GetxController {
  Map<String, dynamic> taskValues() {
    final Map<String, dynamic> data = <String, dynamic>{};
    int speningHours = 1;
    String fullstartingTime = '';
    String fullpinnedTime = '';
    if (startingDate.text.isNotEmpty && pinnedDate.text.isNotEmpty) {
      speningHours = timeHelper.calculateHoursDifference(
          '${startingDate.text} ${startingTime.text}:00.000',
          '${pinnedDate.text} ${pinnedTime.text}:00.000');

      fullstartingTime = '${startingDate.text} ${startingTime.text}:00.000';
      fullpinnedTime = '${pinnedDate.text} ${pinnedTime.text}:00.000';
    }
    int i = int.parse(importancy.text);
    if (i > 10) {
      importancy.text = '10';
    }
    data['task'] = txtCnt.text;
    data['created_time'] = GlobalValues.nowStr;
    data['updated_time'] = GlobalValues.nowStr;
    data['starting_time'] = fullstartingTime;
    data['pinned_time'] = fullpinnedTime;
    data['importancy'] = importancy.text;
    data['spending_time'] = speningHours;
    data['label'] = selectedLabelid;
    data['labelname'] = selectedLabelname;
    data['active'] = 1;
    data['done_it'] = doneIt;
    data['finished_time'] = finishedTime;

    return data;
  }

  final ideaCont = Get.find<IdeaStreamCont>();
  TimeHelper timeHelper = TimeHelper();
  String path = 'tasks';

  RxList taskList = [].obs;
  List entryNames = [];
  Future getAllTask() async {
    try {
      DatabaseEvent a =
          await StaticHelpers.databaseReference.child(path).once();
      if (a.snapshot.exists) {
        Map<dynamic, dynamic> data = a.snapshot.value as Map<dynamic, dynamic>;
        entryNames = data.keys.toList();
        taskList.value = data.values.toList();
        calculateTimeValue(taskList);
      } else {
        taskList.clear();
      }
    } catch (e) {
      Snacks.errorSnack(e);
      print(e);
    }
  }

  calculateTimeValue(List taskList) {
// давталтаар нэг бүрчлэн бодоод үлдсэн хугацаа зарцуулагдах хугацааг нь тооцсон

    for (int i = 0; i < taskList.length; i++) {
      var item = taskList[i];
      int timeValue = int.parse(item['importancy']);
      int remainingHour = 1000;
      if (item['pinned_time'] != '') {
        remainingHour = timeHelper.calculateHoursDifference(
            GlobalValues.nowStr, item['pinned_time']);
      }

      int remainingValue = remainingHour ~/ item['spending_time'];
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
      taskList[i]['timeValue'] = timeValue / 2;
      taskList[i]['remaininghours'] = remainingHour;
    }

    taskList.sort((a, b) => b['timeValue']!.compareTo(a['timeValue']!));
    return taskList;
  }

  int selectedLabelid = 0;
  String selectedLabelname = 'choose box';
  TextEditingController txtCnt = TextEditingController();
  TextEditingController importancy = TextEditingController(text: '1');
  TextEditingController startingDate = TextEditingController();
  TextEditingController pinnedDate = TextEditingController();
  TextEditingController startingTime = TextEditingController();
  TextEditingController pinnedTime = TextEditingController();
  Future insertTask(bool movingIn) async {
    if (txtCnt.text.isNotEmpty) {
      try {
        StaticHelpers.databaseReference
            .child('$path/${StaticHelpers.id}')
            .set(taskValues())
            .whenComplete(() {
          print('dfdf');
          txtCnt.clear();
          startingDate.clear();
          pinnedDate.clear();
          startingTime.clear();
          pinnedTime.clear();
          importancy.text = '1';
          selectedLabelid = 0;
          selectedLabelname = 'choose box';
          if (movingIn) {
            ideaCont.deleteIdea(GlobalValues.movingIncomingIdeaId!);
          }
          Snacks.savedSnack();
        });
      } catch (e) {
        Snacks.errorSnack(e);
      }
    }
    getAllTask();
  }

  void deleteTask(String id) {
    StaticHelpers.databaseReference.child("$path/$id").remove().then((_) {
      getAllTask();
      Get.back();
    });
  }

  int doneIt = 0;
  String finishedTime = '';
  String updatedTime = '';
  Future updateTask(String id) async {
    txtCnt.text = txtCnt.text.trimRight();
    StaticHelpers.databaseReference
        .child('$path/$id')
        .set(taskValues())
        .whenComplete(() {
      getAllTask();
      Get.back();
      Snacks.updatedSnack();
    });
  }

  RxList completedList = [].obs;
  Future getAllCompleted() async {
    try {
      // final db = await Erekdatabase.database;
      // completedList.value = await db.query(tableName, where: 'done_it = 1');
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  RxList dayComplitedTasks = [].obs;
  Future getDayComplitedTasks(String theday) async {
    try {
      // final db = await Erekdatabase.database;
      // dayComplitedTasks.value = await db.query(tableName,
      //     where: 'done_it = ? AND finished_time = ?', whereArgs: ['1', theday]);
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  // var boxTasks = TaskListBody(taskList: []).obs;
  Future getBoxTasks(int boxid) async {
    try {
      // final db = await Erekdatabase.database;
      // var data =
      //     await db.query(tableName, where: 'label = $boxid AND done_it = 0');
      // boxTasks.value = calculateTimeValue(data);
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }
}
