import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../globals.dart';
import '../helpers/work_with_database.dart';
import '../widgets/snacks.dart';
import '../configuration/conf_cont.dart';

class CurrentHabit {
  CurrentHabit(this.actualData, this.isDone);
  dynamic actualData = {};
  bool isDone = false;
}

class HabitCont extends GetxController {
  final confCont = Get.find<ConfigurationCont>();
  String tableName = 'habits';

  WorkLocal workLocalCont = WorkLocal();
  RxList habitList = [].obs;
  RxList<CurrentHabit> packagedList = <CurrentHabit>[].obs;
  Future<dynamic> getAllHabits() async {
    habitList.value = await workLocalCont.fetchData(tableName);
    packageHabits();
  }

  packageHabits() async {
    packagedList.clear();
    for (int i = 0; i < habitList.length; i++) {
      if (habitList[i]['habit_type'] == confCont.habitTypeId.value) {
        bool thereNot = await checkIfThereSameProgress(habitList[i]);
        CurrentHabit newItem;
        newItem = CurrentHabit(habitList[i], thereNot);
        packagedList.add(newItem);
      }
    }
  }

  TextEditingController habitTxtCnt = TextEditingController();
  Map<String, dynamic> selectedValue = GlobalStatics.habitType[0];

  void insertHabit() {
    if (habitTxtCnt.text.isNotEmpty) {
      try {
        workLocalCont.insertData(tableName,
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
    habitTxtCnt.text = habitTxtCnt.text.trimRight();
    bool result = await workLocalCont.updateData(tableName, id,
        {'habit': habitTxtCnt.text, "habit_type": selectedValue['id']});
    result ? getAllHabits() : null;
    habitTxtCnt.clear();
  }

  void deleteHabit(int id) {
    try {
      workLocalCont.deleteData(tableName, 'id', id);
      getAllHabits();
      Get.back();
      habitTxtCnt.clear();

      workLocalCont.deleteData(progressTableName, 'habit_id', id);

      Snacks.deleteSnack();
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

//-------------------------------------
//habit journal ruu hiih crud vildel
  String progressTableName = 'habits_journal';
  RxList progressList = [].obs;
  Future<dynamic> getAllProgress(int HabitId) async {
    progressList.value = await workLocalCont.fetchFilteredData(
        progressTableName, 'habit_id', HabitId);
    print('progress list ${progressList}');
  }

  List ifThere = [];
  Future<bool> checkIfThereSameProgress(dynamic habit) async {
    ifThere = await workLocalCont.fetchTwoFilteredData(
        progressTableName,
        'habit_id',
        habit['id'],
        'day_date',
        DateTime.now().toString().substring(0, 10));

    return ifThere.isEmpty ? true : false;
  }

  TextEditingController stardedtimeofHabit = TextEditingController();
  TextEditingController finfishedtimeofHabit = TextEditingController();
  Future insertTaskProgress(
      dynamic habit, String starting, String finished, String success) async {
    await checkIfThereSameProgress(habit);
    if (ifThere.isEmpty) {
      bool result = await workLocalCont.insertData(progressTableName, {
        'habit': habit['habit'],
        "day_date": DateTime.now().toString().substring(0, 10),
        "starting_time": starting,
        "finished_time": finished,
        "success_count": success,
        "habit_id": habit['id']
      });
      stardedtimeofHabit.clear();
      finfishedtimeofHabit.clear();
      successPointofHabit.clear();
      getAllHabits();
    } else {
      Snacks.warningSnack('Утгийг аль хэдийн нэмсэн байна');
    }
  }

  TextEditingController stardedtimeofHabitedit = TextEditingController();
  TextEditingController finfishedtimeofHabitedit = TextEditingController();
  TextEditingController successPointofHabit = TextEditingController();
  Future updateTaskProgress(int id, int habitId) async {
    bool result = await workLocalCont.updateData(progressTableName, id, {
      'starting_time': stardedtimeofHabit.text,
      "finished_time": finfishedtimeofHabit.text,
      "success_count": successPointofHabit.text
    });
    result ? getAllProgress(habitId) : null;
    stardedtimeofHabit.clear();
    finfishedtimeofHabit.clear();
    successPointofHabit.clear();
  }

  void deleteTaskProgress(int id, int habitId) {
    try {
      workLocalCont.deleteData(progressTableName, 'id', id);
      getAllProgress(habitId);
      getAllHabits();
      Snacks.deleteSnack();
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }
}
