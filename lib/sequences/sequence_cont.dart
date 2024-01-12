import 'dart:typed_data';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../globals.dart';
import '../widgets/snacks.dart';

class SequenceCont extends GetxController {
//#region sequence group CRUD---------------------------------------------------

  createSequenceGroup() async {
    try {
      String id = StaticHelpers.id;
      String imgId = StaticHelpers.id;
      if (boxImg.isNotEmpty) {
        imgPath = await uplodImage(imgId, groupTxt.text);
      }
      if (groupTxt.text.isNotEmpty) {
        StaticHelpers.databaseReference
            .child('$groupPath/$id')
            .set(sequenceGroupData(id, imgPath))
            .whenComplete(() {
          readSequenceGroups();
          clearSequenceGroupfields();
        });
      }
    } catch (e) {
      Snacks.errorSnack("Group creation error: $e");
    }
  }

  readSequenceGroups() async {
    try {
         Query b = StaticHelpers.databaseReference
      
          .child(groupPath)
          .orderByChild('type')
          .equalTo(
            'habit',
          );
      DatabaseEvent a =
          await b.once();
      if (a.snapshot.exists) {
        Map<dynamic, dynamic> data = a.snapshot.value as Map<dynamic, dynamic>;
        groupList.value = data.values.toList();
        checkIsItCurrentGroup();
      } else {
        groupList.clear();
      }
    } catch (e) {
      Snacks.errorSnack("Sequence read error $e");
    }
  }

  updateSequenceGroup(String id) async {
    try {
      StaticHelpers.databaseReference
          .child('$groupPath/$id')
          .set(sequenceGroupData(id, imgPath))
          .whenComplete(() {
        readSequenceGroups();
        groupTxt.clear();
      });
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  deleteSequenceGroup(String id) async {
    try {
      StaticHelpers.databaseReference
          .child('$groupPath/$id')
          .remove()
          .then((_) {
        //id aar ni habituudaas shvvj avaad ter avsan list iinhee key
        //eer  ni davtaad ustgachih yum bna
        readSequenceItems();
        readSequenceGroups();
      });
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

//#endregion sequence group CRUD -----------------------------------------------

//#region sequence item CRUD----------------------------------------------------

  insertSequenceItem() async {
    if (habitTxtCnt.text.isNotEmpty) {
      String id = StaticHelpers.id;
      try {
        StaticHelpers.databaseReference
            .child('$path/$id')
            .set(sequenceItemData(id))
            .whenComplete(() {
          Snacks.savedSnack();
          clearfields();
          readSequenceItems();
        });
      } catch (e) {
        Snacks.errorSnack(e);
      }
    }
  }

  readSequenceItems() async {
    try {
      Query b = StaticHelpers.databaseReference
          .child(path)
          .orderByChild('habit_group_id')
          .equalTo(chosenGroupId);
      DatabaseEvent a = await b.once();
      if (a.snapshot.exists) {
        Map<dynamic, dynamic> data = a.snapshot.value as Map<dynamic, dynamic>;
        seqitems.value = data.values.toList();
        seqitems.sort((a, b) => a['seqnumber'].compareTo(b['seqnumber']));
      } else {
        clearfields();
        seqitems.clear();
      }
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  updateSequenceItem(String id) async {
    try {
      habitTxtCnt.text = habitTxtCnt.text.trimRight();
      StaticHelpers.databaseReference
          .child('$path/$id')
          .set(sequenceItemData(id))
          .whenComplete(() {
        Snacks.savedSnack();
        Future.delayed(const Duration(seconds: 2), () {
          Get.back();
        });
        clearfields();
        readSequenceItems();
      });
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  deleteSequenceItem(String id) async {
    try {
      StaticHelpers.databaseReference.child('$path/$id').remove().then((_) {
        readSequenceItems();
        Get.back();
        clearfields();
        Snacks.deleteSnack();
      });
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

//#endregion sequence item CRUD -----------------------------------------------

//#region habit progression CRUD-------------------------------------------------

  createHabitProgress(String habitName, String habitId) async {
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
          readSequenceItems();
        });
      } catch (e) {
        Snacks.errorSnack(e);
      }
    } else {
      Snacks.warningSnack('Утгийг аль хэдийн нэмсэн байна');
    }
  }

  readAllProgress(String habitId) async {
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

  updateHabitProgress(String id, String habitId, String habitname) async {
    try {
      StaticHelpers.databaseReference
          .child('$progresspath/$id')
          .set(habitprogressValues(habitname, habitId))
          .whenComplete(() {
        stardedtimeofHabit.clear();
        finfishedtimeofHabit.clear();
        successPointofHabit.clear();
        readAllProgress(habitId);
      });
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  deleteHabitProgress(String id, String habitId) async {
    try {
      StaticHelpers.databaseReference
          .child('$progresspath/$id')
          .remove()
          .then((_) {
        readAllProgress(habitId);
        readSequenceItems();
        Snacks.deleteSnack();
      });
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

//#endregion habit progression CRUD---------------------------------------------

//#region helpers---------------------------------------------------------------

  checkIsItCurrentGroup() {
    DateTime now = DateTime.now();
    for (int i = 0; i < groupList.length; i++) {
      if (groupList[i]['repeatType'] == 'weekly') {
        List weekDays = groupList[i]['weeklyDays'];
        for (int ii = 0; ii < weekDays.length; ii++) {
          if (weekDays[ii] == now.weekday) {
            checkIsItCurrentTime(now, groupList[i]['startTime'],
                groupList[i]['endTime'], groupList[i]['id']);
          }
        }
      } else if (groupList[i]['repeatType'] == 'monthly') {
        if (groupList[i]['monthDay'] == now.day.toString()) {
          checkIsItCurrentTime(now, groupList[i]['startTime'],
              groupList[i]['endTime'], groupList[i]['id']);
        }
      }
    }
  }

  checkIsItCurrentTime(
      DateTime nw, String startTime, String endTime, String groupId) {
    int nowStr = int.parse('${nw.hour}${nw.minute}');
    String a = startTime.replaceAll(":", "");
    int start = int.parse(startTime.replaceAll(":", ""));
    int end = int.parse(endTime.replaceAll(":", ""));
    if (nowStr > start && nowStr < end) {
      chosenGroupId = groupId;
      readSequenceItems();
      StaticHelpers.homeMiddleAreaType.value = 'packagedHabits';
    }
  }

  Map<String, dynamic> sequenceGroupData(String id, String imgPath) {
    Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = 'habit';
    data['discription'] = discripctionTxt.text;
    data['imgPath'] = imgPath;
    data['id'] = id;
    data['name'] = groupTxt.text;
    data['startTime'] = startTime.text;
    data['endTime'] = endTime.text;
    data['repeatType'] = type;
    data['weeklyDays'] = weekday;
    data['monthDay'] =
        monthDay.isEmpty ? '' : monthDay.substring(monthDay.length - 2);
    return data;
  }

  Map<String, dynamic> sequenceItemData(String id) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['habit'] = habitTxtCnt.text;
    data['habit_group_id'] = chosenGroupId;
    data['seqnumber'] = int.parse(seqnumber.text);
    data['importancy'] = int.parse(importancy.text);
    data['ismoveable'] = isMoveable;
    return data;
  }

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

  clearfields() {
    habitTxtCnt.clear();
    importancy.clear();
    seqnumber.clear();
    isMoveable = false;
  }

  clearSequenceGroupfields() {
    groupTxt.clear();
    startTime.clear();
    endTime.clear();
    type = '';
    weekday.clear();
    monthDay = '';
  }

  dayHabitProgress(String theday) async {
    try {
      // final db = await Erekdatabase.database;
      // dayProgress.value = await db
      //     .query(progressTableName, where: 'day_date = ?', whereArgs: [theday]);
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

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

  /// Зургийн firebase storage дээр хадаглах func
  Future uplodImage(String productId, String imgName) async {
    final storage = FirebaseStorage.instance;
    final metaData = SettableMetadata(contentType: 'image/png');

    final reference = storage
        .ref()
        .child('${StaticHelpers.userInfo!.uid}/box_pics/$productId')
        .child(imgName);
    UploadTask uploadTask = reference.putData(boxImg[0], metaData);
    TaskSnapshot snapShot = await uploadTask.whenComplete(() {
      boxImg.clear();
      print('proccess complited');
    });
    final imageUrl = await snapShot.ref.getDownloadURL();
    return imageUrl;
  }

//#endregion helpers------------------------------------------------------------

//#region variables-------------------------------------------------------------

  /// firebase realtime database deerh swequence iin zam
  String path = '';

  /// firebase realtime database deerh swequence iin groupiin zam
  String groupPath = '';

  /// firebase realtime database deerh swequence iin progress iin zam
  String progresspath = '';

  /// songoson sequence group dotorh itemiin list
  RxList seqitems = [].obs;

  ///txt input for sequence item
  TextEditingController habitTxtCnt = TextEditingController();

  ///sequence number input for sequence item
  TextEditingController seqnumber = TextEditingController();

  ///importancy number input for sequence item
  TextEditingController importancy = TextEditingController();

  ///bool for whether it is can be moved in to front screen or not
  bool isMoveable = false;

  ///chosen sequence group id
  String chosenGroupId = '';

  /// sequence iin biyleltiig haruulsan bool list
  RxList isDone = [].obs;

  /// sequence repeat type
  String type = '';

  /// хэрвээ 7 хоногоор гэж сонгосон бол давтагдах өдрүүдийн жагсаалт
  List<int> weekday = [];

  /// сараар гэж сонгосон бол сард давтагдах өдөр нь
  String monthDay = '';

  /// sequence name
  TextEditingController groupTxt = TextEditingController();

  /// тухайн sequence ийн ил болох цаг
  TextEditingController startTime = TextEditingController();

  /// тухайн sequence ийн дуусах цаг
  TextEditingController endTime = TextEditingController();

  /// progress дээр бичигдэх habit ын эхэлсэн цаг
  TextEditingController stardedtimeofHabit = TextEditingController();

  /// progress дээр бичигдэх habit ын дууссан цаг
  TextEditingController finfishedtimeofHabit = TextEditingController();

  /// тайлбар
  TextEditingController discripctionTxt = TextEditingController();

  /// зургийн замыг хадаглах str
  String imgPath = '';

  /// зургийг Uint8List хэлбэрээр агуулах
  RxList<Uint8List> boxImg = <Uint8List>[].obs;

  RxList groupList = [].obs;
  RxList progressList = [].obs;
  List progressEntries = [];
  TextEditingController successPointofHabit = TextEditingController();
  RxList dayProgress = [].obs;
  List ifThere = [];

//#endregion variables----------------------------------------------------------
}
