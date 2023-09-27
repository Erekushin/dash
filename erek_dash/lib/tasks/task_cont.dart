import 'package:erek_dash/globals.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helpers/time.dart';
import '../idea_stream/idea_stream_cont.dart';
import 'task_model.dart';
import '../widgets/snacks.dart';

class TaskCont extends GetxController {
  final ideaCont = Get.find<IdeaStreamCont>();
  TimeHelper timeHelper = TimeHelper();
  Task task = Task();
  String tableName = 'tasks';

  // var taskListBody = TaskListBody(taskList: []).obs;
  // Future<dynamic> getAll() async {
  //   try {
  //     final db = await Erekdatabase.database;
  //     var data = await db.query(tableName, where: 'active = 1 AND done_it = 0');

  //     taskListBody.value = calculateTimeValue(data);
  //   } catch (e) {
  //     Snacks.errorSnack(e);
  //   }
  //   // print(const JsonEncoder.withIndent('  ').convert(taskList[0]));
  // }

  RxList taskList = [].obs;
  Future getAllTask() async {
    taskList.clear();
    const String path = 'orders';
    try {
      DatabaseReference reference = StaticHelpers.databaseReference.child(path);
      // Set up a real-time listener.
      reference.onValue.listen((DatabaseEvent event) {
        if (event.snapshot.exists) {
          Map<dynamic, dynamic> data =
              event.snapshot.value as Map<dynamic, dynamic>;
          data.forEach((key, value) {
            taskList.add(Map<String, dynamic>.from(value));
          });
        }
      }, onError: (Object error) {
        // Handle any errors that occur during the listening process.
        print("Error: $error");
      });
    } catch (e) {
      print('error $e');
    }
  }

  TaskListBody calculateTimeValue(givenData) {
// давталтаар нэг бүрчлэн бодоод үлдсэн хугацаа зарцуулагдах хугацааг нь тооцсон
    var innertaskListBody = TaskListBody(taskList: []);
    innertaskListBody = TaskListBody.fromJson(givenData);
    for (int i = 0; i < innertaskListBody.taskList.length; i++) {
      var item = innertaskListBody.taskList[i];
      int timeValue = item.importancy!;
      int remainingHour = 1000;
      if (item.pinnedTime! != '') {
        remainingHour = timeHelper.calculateHoursDifference(
            GlobalValues.nowStr, item.pinnedTime!);
      }

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
      innertaskListBody.taskList[i].timeValue = timeValue / 2;
      innertaskListBody.taskList[i].remaininghours = remainingHour;
    }

    innertaskListBody.taskList
        .sort((a, b) => b.timeValue!.compareTo(a.timeValue!));
    return innertaskListBody;
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

  RxList dayComplitedTasks = [].obs;
  Future getDayComplitedTasks(String theday) async {
    try {
      final db = await Erekdatabase.database;
      dayComplitedTasks.value = await db.query(tableName,
          where: 'done_it = ? AND finished_time = ?', whereArgs: ['1', theday]);
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  var boxTasks = TaskListBody(taskList: []).obs;
  Future getBoxTasks(int boxid) async {
    try {
      final db = await Erekdatabase.database;
      var data =
          await db.query(tableName, where: 'label = $boxid AND done_it = 0');
      boxTasks.value = calculateTimeValue(data);
    } catch (e) {
      Snacks.errorSnack(e);
    }
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
        final db = await Erekdatabase.database;
        await db.insert(tableName, {
          'task': txtCnt.text,
          'created_time': GlobalValues.nowStr,
          'updated_time': GlobalValues.nowStr,
          'starting_time': fullstartingTime,
          'pinned_time': fullpinnedTime,
          'importancy': importancy.text,
          'spending_time': speningHours,
          'label': selectedLabelid,
          'labelname': selectedLabelname,
          'active': 1,
          'done_it': 0
        });
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
      } catch (e) {
        Snacks.errorSnack(e);
      }
    }
    getAllTask();
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
    getAllTask();
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
    getAllTask();
  }
}
