import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../globals.dart';
import '../widgets/snacks.dart';

class CurrentHabit {
  CurrentHabit(this.actualData, this.isDone);
  dynamic actualData = {};
  bool isDone = false;
}

class HabitCont extends GetxController {
  DateTime now1 = DateTime.now();

  HabitCont() {
    DateTime now = DateTime(now1.year, now1.month, now1.day, now1.hour, 0, 0);
    for (int i = 0; i < GlobalStatics.habitType.length; i++) {
      var item = GlobalStatics.habitType[i];
      if (now.hour >= item['upperthat'] && now.hour <= item['downerthat']) {
        currentHabitTypeId = item['id'];
        GlobalValues.homeScreenType = HomeScreenType.packagedHabits;
      }
    }
  }
  String tableName = 'habits';

  RxList habitList = [].obs;
  RxList<CurrentHabit> packagedList = <CurrentHabit>[].obs;
  Future<dynamic> getAllHabits() async {
    try {
      // final db = await Erekdatabase.database;
      // habitList.value = await db.query(tableName);
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
        bool thereNot = await checkIfThereSameProgress(habitList[i]);
        CurrentHabit newItem;
        newItem = CurrentHabit(habitList[i], thereNot);
        packagedList.add(newItem);
      }
    }
  }

  TextEditingController habitTxtCnt = TextEditingController();
  Map<String, dynamic> selectedValue = GlobalStatics.habitType[0];

  Future insertHabit() async {
    if (habitTxtCnt.text.isNotEmpty) {
      try {
        final db = await Erekdatabase.database;
        db.insert(tableName,
            {'habit': habitTxtCnt.text, "habit_type": selectedValue['id']});
        Snacks.savedSnack();
        habitTxtCnt.clear();
        getAllHabits();
      } catch (e) {
        Snacks.errorSnack(e);
      }
    }
  }

  Future updateHabit(int id) async {
    try {
      habitTxtCnt.text = habitTxtCnt.text.trimRight();
      final db = await Erekdatabase.database;
      db.update(
        tableName,
        {'habit': habitTxtCnt.text, "habit_type": selectedValue['id']},
        where: 'id = $id',
      );

      getAllHabits();
      habitTxtCnt.clear();
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  void deleteHabit(int id) async {
    try {
      final db = await Erekdatabase.database;
      db.delete(tableName, where: 'id = $id');
      getAllHabits();
      Get.back();
      habitTxtCnt.clear();

      db.delete(progressTableName, where: 'habit_id = $id');

      Snacks.deleteSnack();
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

//-------------------------------------
//habit journal ruu hiih crud vildel
  String progressTableName = 'habits_journal';
  RxList progressList = [].obs;
  Future getAllProgress(int habitId) async {
    try {
      final db = await Erekdatabase.database;
      progressList.value = await db.query(
        progressTableName,
        where: 'habit_id = $habitId',
      );
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  RxList dayProgress = [].obs;
  Future dayHabitProgress(String theday) async {
    try {
      final db = await Erekdatabase.database;
      dayProgress.value = await db
          .query(progressTableName, where: 'day_date = ?', whereArgs: [theday]);
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  List ifThere = [];
  Future<bool> checkIfThereSameProgress(dynamic habit) async {
    try {
      final db = await Erekdatabase.database;
      ifThere = await db.query(progressTableName,
          where: 'habit_id = ? AND day_date = ?',
          whereArgs: [habit['id'], GlobalValues.nowStrShort]);

      return ifThere.isEmpty ? true : false;
    } catch (e) {
      Snacks.errorSnack(e);
      return false;
    }
  }

  TextEditingController stardedtimeofHabit = TextEditingController();
  TextEditingController finfishedtimeofHabit = TextEditingController();
  Future insertHabitProgress(
      dynamic habit, String starting, String finished, String success) async {
    await checkIfThereSameProgress(habit);
    if (ifThere.isEmpty) {
      try {
        final db = await Erekdatabase.database;
        db.insert(progressTableName, {
          'habit': habit['habit'],
          "day_date": GlobalValues.nowStrShort,
          "starting_time": starting,
          "finished_time": finished,
          "success_count": success,
          "habit_id": habit['id']
        });
        stardedtimeofHabit.clear();
        finfishedtimeofHabit.clear();
        successPointofHabit.clear();
        getAllHabits();
      } catch (e) {
        Snacks.errorSnack(e);
      }
    } else {
      Snacks.warningSnack('Утгийг аль хэдийн нэмсэн байна');
    }
  }

  TextEditingController stardedtimeofHabitedit = TextEditingController();
  TextEditingController finfishedtimeofHabitedit = TextEditingController();
  TextEditingController successPointofHabit = TextEditingController();
  Future updateTaskProgress(int id, int habitId) async {
    try {
      final db = await Erekdatabase.database;
      db.update(
          progressTableName,
          {
            'starting_time': stardedtimeofHabit.text,
            "finished_time": finfishedtimeofHabit.text,
            "success_count": successPointofHabit.text
          },
          where: 'id = $id');
      getAllProgress(habitId);
      stardedtimeofHabit.clear();
      finfishedtimeofHabit.clear();
      successPointofHabit.clear();
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  void deleteTaskProgress(int id, int habitId) async {
    try {
      final db = await Erekdatabase.database;
      db.delete(progressTableName, where: 'id = $id');
      getAllProgress(habitId);
      getAllHabits();
      Snacks.deleteSnack();
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }
}
