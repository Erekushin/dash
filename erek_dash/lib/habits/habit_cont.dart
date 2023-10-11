import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../globals.dart';
import '../widgets/snacks.dart';
import 'habit_list.dart';

class CurrentHabit {
  CurrentHabit(this.actualData, this.id, this.isDone);
  dynamic actualData = {};
  int id;
  bool isDone = false;
}

class HabitCont extends GetxController {
  DateTime now1 = DateTime.now();

  HabitCont() {
    DateTime now = DateTime(now1.year, now1.month, now1.day, now1.hour, 0, 0);
    for (int i = 0; i < groupList.length; i++) {
      var item = groupList[i];
      if (now.hour >= item['upperthat'] && now.hour <= item['downerthat']) {
        currentHabitTypeId = item['id'];
        GlobalValues.homeScreenType = HomeScreenType.packagedHabits;
      }
    }
  }
  String path = 'habit/habits';

  RxList habitList = [].obs;
  List entryNames = [];
  RxList<CurrentHabit> packagedList = <CurrentHabit>[].obs;
  Future<dynamic> getAllHabits() async {
    try {
      DatabaseEvent a =
          await StaticHelpers.databaseReference.child(path).once();
      if (a.snapshot.exists) {
        Map<dynamic, dynamic> data = a.snapshot.value as Map<dynamic, dynamic>;
        entryNames = data.keys.toList();
        habitList.value = data.values.toList();
      } else {
        habitList.clear();
      }
      packageHabits();
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  int currentHabitTypeId = 0;
  packageHabits() async {
    packagedList.clear();
    for (int i = 0; i < habitList.length; i++) {
      if (habitList[i]['habit_type'] == currentHabitTypeId) {
        bool thereNot = await checkIfThereSameProgress(entryNames[i]);
        CurrentHabit newItem;
        newItem =
            CurrentHabit(habitList[i], int.parse(entryNames[i]), thereNot);
        packagedList.add(newItem);
      }
    }
  }

  TextEditingController habitTxtCnt = TextEditingController();
  String chosenGroup = '';

  Map<String, dynamic> habitValues() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['habit'] = habitTxtCnt.text;
    data['habit_type'] = chosenGroup;
    return data;
  }

  Future insertHabit() async {
    if (habitTxtCnt.text.isNotEmpty) {
      try {
        StaticHelpers.databaseReference
            .child('$path/${StaticHelpers.id}')
            .set(habitValues())
            .whenComplete(() {
          Snacks.savedSnack();
          habitTxtCnt.clear();
          getAllHabits();
        });
      } catch (e) {
        Snacks.errorSnack(e);
      }
    }
  }

  Future updateHabit(String id) async {
    try {
      habitTxtCnt.text = habitTxtCnt.text.trimRight();
      StaticHelpers.databaseReference
          .child('$path/$id')
          .set(habitValues())
          .whenComplete(() {
        Snacks.savedSnack();
        Future.delayed(const Duration(seconds: 2), () {
          Get.back();
        });
        habitTxtCnt.clear();
        getAllHabits();
      });
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  void deleteHabit(String id) async {
    try {
      StaticHelpers.databaseReference.child('$path/$id').remove().then((_) {
        getAllHabits();
        Get.back();
        habitTxtCnt.clear();
        Snacks.deleteSnack();
      });
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

//-------------------------------------
//habit journal ruu hiih crud vildel
  String progresspath = 'habits_journal';
  RxList progressList = [].obs;
  List progressEntries = [];
  Future getAllProgress(String habitId) async {
    try {
      Query b = StaticHelpers.databaseReference
          .child(progresspath)
          .orderByChild('habit_id')
          .equalTo(habitId);
      DatabaseEvent a = await b.once();
      print('progress value ${a.snapshot.value}');
      if (a.snapshot.exists) {
        Map<dynamic, dynamic> data = a.snapshot.value as Map<dynamic, dynamic>;
        progressEntries = data.keys.toList();
        progressList.value = data.values.toList();
      } else {
        progressList.clear();
      }
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  RxList dayProgress = [].obs;
  Future dayHabitProgress(String theday) async {
    try {
      // final db = await Erekdatabase.database;
      // dayProgress.value = await db
      //     .query(progressTableName, where: 'day_date = ?', whereArgs: [theday]);
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  List ifThere = [];
  Future<bool> checkIfThereSameProgress(String habitId) async {
    try {
      // final db = await Erekdatabase.database;
      // ifThere = await db.query(progressTableName,
      //     where: 'habit_id = ? AND day_date = ?',
      //     whereArgs: [habit['id'], GlobalValues.nowStrShort]);

      return ifThere.isEmpty ? true : false;
    } catch (e) {
      Snacks.errorSnack(e);
      return false;
    }
  }

  TextEditingController stardedtimeofHabit = TextEditingController();
  TextEditingController finfishedtimeofHabit = TextEditingController();
  Map<String, dynamic> habitprogressValues(String habitName, String habitId) {
    Map<String, dynamic> data = <String, dynamic>{};
    data['habit'] = habitName;
    data['day_date'] = GlobalValues.nowStrShort;
    data['starting_time'] = stardedtimeofHabit.text;
    data['finished_time'] = finfishedtimeofHabit.text;
    data['success_count'] = successPointofHabit.text;
    data['habit_id'] = habitId;
    return data;
  }

  Future insertHabitProgress(String habitName, String habitId) async {
    await checkIfThereSameProgress(habitId);
    if (ifThere.isEmpty) {
      try {
        StaticHelpers.databaseReference
            .child('$progresspath/${StaticHelpers.id}')
            .set(habitprogressValues(habitName, habitId))
            .whenComplete(() {
          stardedtimeofHabit.clear();
          finfishedtimeofHabit.clear();
          successPointofHabit.clear();
          getAllHabits();
        });
      } catch (e) {
        Snacks.errorSnack(e);
      }
    } else {
      Snacks.warningSnack('Утгийг аль хэдийн нэмсэн байна');
    }
  }

  TextEditingController successPointofHabit = TextEditingController();
  Future updateTaskProgress(String id, String habitId, String habitname) async {
    try {
      StaticHelpers.databaseReference
          .child('$progresspath/$id')
          .set(habitprogressValues(habitname, habitId))
          .whenComplete(() {
        stardedtimeofHabit.clear();
        finfishedtimeofHabit.clear();
        successPointofHabit.clear();
        getAllProgress(habitId);
      });
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  void deleteTaskProgress(String id, String habitId) async {
    try {
      StaticHelpers.databaseReference
          .child('$progresspath/$id')
          .remove()
          .then((_) {
        getAllProgress(habitId);
        getAllHabits();
        Snacks.deleteSnack();
      });
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  //----------------------habit groups-----------------------
  String groupPath = 'habit/groups';

  RxList groupList = [].obs;
  List groupEntries = [];
  Future allGroups() async {
    try {
      DatabaseEvent a =
          await StaticHelpers.databaseReference.child(groupPath).once();
      if (a.snapshot.exists) {
        Map<dynamic, dynamic> data = a.snapshot.value as Map<dynamic, dynamic>;
        groupList.value = data.values.toList();
        groupEntries = data.keys.toList();
      } else {
        groupList.clear();
        groupEntries.clear();
      }
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  Map<String, dynamic> groupValues() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = gemTxt.text;
    data['upperthat'] = 5;
    data['downerthat'] = 7;
    return data;
  }

  TextEditingController gemTxt = TextEditingController();
  insertGroup() async {
    try {
      if (gemTxt.text.isNotEmpty) {
        StaticHelpers.databaseReference
            .child('$groupPath/${StaticHelpers.id}')
            .set(groupValues())
            .whenComplete(() {
          allGroups();
          gemTxt.clear();
        });
      }
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  updateGroup(String id) async {
    try {
      StaticHelpers.databaseReference
          .child('$groupPath/$id')
          .set(groupValues())
          .whenComplete(() {
        allGroups();
        gemTxt.clear();
      });
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  deleteGroup(String id) async {
    try {
      StaticHelpers.databaseReference
          .child('$groupPath/$id')
          .remove()
          .then((_) {
        allGroups();
      });
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }
}
