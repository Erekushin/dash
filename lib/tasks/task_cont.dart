import 'package:erek_dash/globals.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helpers/time.dart';
import '../idea_stream/idea_stream_cont.dart';
import '../widgets/snacks.dart';

class TaskCont extends GetxController {
  final ideaCont = Get.find<IdeaStreamCont>();
  String path = '';
  TimeHelper timeHelper = TimeHelper();
  RxBool loadingVis = false.obs;

  RxString homeMiddleAreaType = 'allTasks'.obs;

  List allActiveTasks = [];
  RxList taskList = [].obs;
  Future getAllTask() async {
    try {
      loadingVis.value = true;
      Query b = StaticHelpers.databaseReference
      
          .child(path)
          .orderByChild('done_it')
          .equalTo(
            0,
          );
      DatabaseEvent a = await b.once();
      if (a.snapshot.exists) {
        Map<dynamic, dynamic> data = a.snapshot.value as Map<dynamic, dynamic>;
        List entryNames = [];
        List values = [];
        entryNames = data.keys.toList();
        values = data.values.toList();

        allActiveTasks.clear();
        for (int i = 0; i < entryNames.length; i++) {
          allActiveTasks.add({
            'id': entryNames[i],
            'value': values[i],
          });
        }
        if (homeMiddleAreaType.value == 'allTasks') {
          taskList.value = allActiveTasks;
          calculateTimeValue(taskList);
        } else if (homeMiddleAreaType.value == 'now') {
          getBoxTasks('now');
        } else if (homeMiddleAreaType.value == 'outer') {
          getBoxTasks('');
        } else {
          getBoxTasks(homeMiddleAreaType.value);
        }
      } else {
        taskList.clear();
      }
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  Future insertTask(bool movingIn) async {
    if (txtCnt.text.isNotEmpty) {
      try {
        StaticHelpers.databaseReference
            .child('$path/${StaticHelpers.id}')
            .set(taskValues())
            .whenComplete(() async {
          await getAllTask();
          clearValues();

          if (movingIn) {
            ideaCont.deleteIdea(GlobalValues.movingIncomingIdeaId!);
          }
          Snacks.savedSnack();
        });
      } catch (e) {
        Snacks.errorSnack(e);
      }
    }
  }

  Future updateTask(String id) async {
    txtCnt.text = txtCnt.text.trimRight();
    StaticHelpers.databaseReference
        .child('$path/$id')
        .set(taskValues())
        .whenComplete(() {
      getAllTask();
      Get.back();
      clearValues();
      Snacks.updatedSnack();
    });
  }

  Future deleteTask(String id) async {
    StaticHelpers.databaseReference.child("$path/$id").remove().then((_) {
      getAllTask();
      Get.back();
    });
  }

  //value properties of individual task
  //--------------------------------------
  String boxId = '';
  String boxName = 'choose box';
  TextEditingController txtCnt = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController startingDate = TextEditingController();
  TextEditingController pinnedDate = TextEditingController();
  TextEditingController startingTime = TextEditingController();
  TextEditingController pinnedTime = TextEditingController();
  TextEditingController importancy = TextEditingController(text: '1');
  bool isActive = true;
  int doneIt = 0;
  String finishedTime = '';
  String updatedTime = '';
  //---------------------------------------

  //package values into map data
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
    if (homeMiddleAreaType.value == 'now') {
      boxId = 'now';
    }
    data['task'] = txtCnt.text;
    data['description'] = description.text;
    data['created_time'] = GlobalValues.nowStr;
    data['updated_time'] = GlobalValues.nowStr;
    data['starting_time'] = fullstartingTime;
    data['pinned_time'] = fullpinnedTime;
    data['importancy'] = importancy.text;
    data['spending_time'] = speningHours;
    data['boxId'] = boxId;
    data['boxname'] = boxName;
    data['active'] = isActive;
    data['done_it'] = doneIt;
    data['finished_time'] = finishedTime;

    return data;
  }

  //set values to it's properties to update an task item
  void setValues(item) {
    txtCnt.text = item['task'];
    startingDate.text = item['starting_time'] ??
        item['starting_time'].toString().substring(0, 10);
    startingTime.text = item['starting_time'] ??
        item['starting_time'].toString().substring(11, 16);
    pinnedDate.text =
        item['pinned_time'] ?? item['pinned_time'].toString().substring(0, 10);
    pinnedTime.text =
        item['pinned_time'] ?? item['pinned_time'].toString().substring(11, 16);
    importancy.text = item['importancy'];
    boxId = item['boxId'];
  }

  clearValues() {
    boxId = '';
    boxName = 'choose box';
    txtCnt.clear();
    description.clear();
    startingDate.clear();
    startingTime.clear();
    pinnedDate.clear();
    pinnedTime.clear();
    finishedTime = '';
    updatedTime = '';
    doneIt = 0;
    importancy.text = '1';
  }

  RxList completedList = [].obs;
  List completedEntryNames = [];
  Future getAllCompleted() async {
    try {
      Query b = StaticHelpers.databaseReference
          .child(path)
          .orderByChild('done_it')
          .equalTo(1);
      DatabaseEvent a = await b.once();
      if (a.snapshot.exists) {
        Map<dynamic, dynamic> data = a.snapshot.value as Map<dynamic, dynamic>;
        completedEntryNames = data.keys.toList();
        completedList.value = data.values.toList();
      } else {
        completedList.clear();
      }
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  RxList dayComplitedTasks = [].obs;
  Future getDayComplitedTasks(String theday) async {
    try {
      Query b = StaticHelpers.databaseReference
          .child(path)
          .orderByChild('finished_time')
          .equalTo(
            theday,
          );

      DatabaseEvent a = await b.once();
      if (a.snapshot.exists) {
        //done it iin filter bichih
        List c = [];
        Map<dynamic, dynamic> data = a.snapshot.value as Map<dynamic, dynamic>;
        c = data.values.toList();
        print(c.toString());
        dayComplitedTasks
            .assignAll(c.where((element) => element['done_it'] == 1));

        print(dayComplitedTasks.value.toString());
      }
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  // calculate remaining our and spending hours and order them
  calculateTimeValue(List taskList) {
    for (int i = 0; i < taskList.length; i++) {
      var item = taskList[i]['value'];
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
      taskList[i]['value']['timeValue'] = timeValue / 2;
      taskList[i]['value']['remaininghours'] = remainingHour;
      
    }

    taskList.sort(
        (a, b) => b['value']['timeValue']!.compareTo(a['value']['timeValue']!));
        loadingVis.value = false;
    return taskList;
  }

  ///filter [allActiveTasks] by boxId
  Future getBoxTasks(String boxid) async {
    loadingVis.value = true;
    try {
      List boxTasks = allActiveTasks
          .where((element) => element['value']['boxId'] == boxid)
          .toList();
      taskList.value = boxTasks;
      calculateTimeValue(taskList);
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  //money Stream
}
