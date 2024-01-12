import 'dart:typed_data';

import 'package:erek_dash/globals.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helpers/time.dart';
import '../idea_stream/idea_stream_cont.dart';
import '../widgets/snacks.dart';
import 'package:flutter_treeview/flutter_treeview.dart' as treeview;

class TaskCont extends GetxController {
  //#region task CRUD ----------------------------------------------------------
  Future createTask(bool movingIn) async {
    if (txtCnt.text.isNotEmpty) {
      try {
        loadingVis.value = true;
        String id = StaticHelpers.id;
        if (boxImg.isNotEmpty) {
          imgPath = await uplodImage(id, txtCnt.text);
        }
        StaticHelpers.databaseReference
            .child('$path/$id')
            .set(taskValues(id))
            .whenComplete(() async {
          await readTasks();
          clearValues();
          Get.back();
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

  Future readTasks() async {
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
        allUnComlitedTasks = data.values.toList();
        alllightTasks = allUnComlitedTasks
            .where((element) => element['step'] == 1)
            .toList();
        boxList.value = allUnComlitedTasks
            .where((element) =>
                element['initialTaskId'] == "LastTask" &&
                element['boxId'] == "" &&
                element['importancy'] == "10")
            .toList();
        if (StaticHelpers.homeMiddleAreaType.value == 'allTasks') {
          lightTasks.value = alllightTasks;
          calculateTimeValue(lightTasks);
        } else if (StaticHelpers.homeMiddleAreaType.value == 'now') {
          lightTasks.value = await classifyBoxtasks('now', alllightTasks);
        } else if (StaticHelpers.homeMiddleAreaType.value == 'outer') {
          lightTasks.value = await classifyBoxtasks('', alllightTasks);
        } else {
          lightTasks.value = await classifyBoxtasks(
              StaticHelpers.homeMiddleAreaType.value, alllightTasks);
        }
      } else {
        loadingVis.value = false;
        lightTasks.clear();
        boxList.clear();
      }
    } catch (e) {
      Snacks.errorSnack('during read tasks : $e');
    }
  }

  Future updateTask(String id, String imgpath) async {
    txtCnt.text = txtCnt.text.trimRight();
    //zuragaa solij bgaa bol huuchin zuragiig ni ustgaad
    //shine zuragiig ni hadaglah
    if (boxImg.isNotEmpty) {
      if (imgpath != '') {
        deleteImageFromStorage(imgpath);
      }
      imgPath = await uplodImage(id, txtCnt.text);
    }
    StaticHelpers.databaseReference
        .child('$path/$id')
        .set(taskValues(id))
        .whenComplete(() {
      readTasks();
      Get.back();
      clearValues();
      Snacks.updatedSnack();
    });
  }

  Future deleteTask(String id, String imgpath) async {
    if (imgpath != '') {
      deleteImageFromStorage(imgpath);
    }
    StaticHelpers.databaseReference.child("$path/$id").remove().then((_) {
      readTasks();
      Get.back();
    });
  }
  //#endregion task CRUD--------------------------------------------------------

  //#region helpers-------------------------------------------------------------

  /// box ийн task уудыг treeview дотор оруулах func
  Future classifyTaskTree(String boxid) async {
    try {
      //бүх биелэгдээгүй task уудаас тухайн box ийнхийг ялгаж авна.
      List boxTasks = await classifyBoxtasks(boxid, allUnComlitedTasks);
      //тухайн box ын task уудаас Last step үүдийг ялгаж авна
      List lastSteps = boxTasks
          .where((element) => element['initialTaskId'] == 'LastTask')
          .toList();
      //давталтаар нэмэх учир list ээ цэвэрлэнэ
      treeTasks.clear();
      //давталтаар last step бүр дээр бүрэн угсрагдсан subtask list ийг өнгө
      for (int i = 0; i < lastSteps.length; i++) {
        treeview.Node tasknode = treeview.Node(
            key: 'task',
            label: lastSteps[i]['task'],
            data: lastSteps[i],
            children: checkSubs(lastSteps[i]['id'], boxTasks));
        treeTasks.add(tasknode);
      }
    } catch (e) {
      Snacks.errorSnack('during read box tree tasks : $e');
    }
  }

  /// subtask list ийг бүрэн угсарч явуулах func
  List<treeview.Node> checkSubs(id, List<dynamic> boxTasks) {
    //subtask tree ийг агуулаад буцаах list
    List<treeview.Node> littleSubTree = <treeview.Node>[];
    //ялгагдсан boxTaks аас өгөдсөн id аар initialTaskId тай нь тааруулж subtask үгүүг нь
    //тааруулж ялгаж авна
    for (int ii = 0; ii < boxTasks.length; ii++) {
      if (boxTasks[ii]['initialTaskId'] == id) {
        treeview.Node taskItem;
        taskItem = treeview.Node(
            key: 'task',
            label: boxTasks[ii]['task'],
            data: boxTasks[ii],
            //subtask өөрийн гэсэн subtask агуулж болох учир loop лэн хайсаар байна.
            children: checkSubs(boxTasks[ii]['id'], boxTasks));
        littleSubTree.add(taskItem);
      }
    }
    return littleSubTree;
  }

  ///📒 calculate remaining hour and spending hours and order them
  List<dynamic> calculateTimeValue(List taskList) {
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
    loadingVis.value = false;
    return taskList;
  }

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

  Future<List<dynamic>> classifyBoxtasks(
      String boxid, List<dynamic> incomingTasks) async {
    List<dynamic> boxTasks = [];
    try {
      boxTasks =
          incomingTasks.where((element) => element['boxId'] == boxid).toList();
      boxTasks = await calculateTimeValue(boxTasks);
    } catch (e) {
      Snacks.errorSnack('during classifyBoxtasks $e');
    }
    return boxTasks;
  }

  Future readParentTask(item) async {
    //get individual task
    try {
      //шууд энэ task аа level нэмнэ.
      item['step']++;
      setValues(item);
      updateTask(item['id'], item['imgPath']);
      //last task байвал parent хайхгүй
      if (item['initialTaskId'] != "LastTask") {
        //биш бол ороод
        Query b = StaticHelpers.databaseReference
            .child(path)
            .orderByChild('id')
            .equalTo(
              item['initialTaskId'],
            );
        DatabaseEvent a = await b.once();
        if (a.snapshot.exists) {
          Map<dynamic, dynamic> data =
              a.snapshot.value as Map<dynamic, dynamic>;
          var item;
          item = data.values.toList()[0];

          // readTasksinOneLevel(item['initialTaskId'], item['boxId']);
          //parent ийг нь аваад явуулчих нь.
          readParentTask(item);
        }
      } else {}
    } catch (e) {
      Snacks.errorSnack('During Read initial task : $e');
    }
  }

  // Future readTasksinOneLevel(String initId, String boxid) async {
  //   try {
  //     Query b = StaticHelpers.databaseReference
  //         .child(path)
  //         .orderByChild('initialTaskId')
  //         .equalTo(
  //           initId,
  //         );
  //     DatabaseEvent a = await b.once();
  //     if (a.snapshot.exists) {
  //       Map<dynamic, dynamic> data = a.snapshot.value as Map<dynamic, dynamic>;

  //       List items = data.values.toList();
  //       items = items.where((element) => element['boxId'] == boxid).toList();
  //       ;
  //       for (int o = 0; o < items.length; o++) {
  //         items[o]['step']++;
  //         setValues(items[o]);
  //         updateTask(items[o]['id'], items[o]['imgPath']);
  //         if (o == items.length - 1 &&
  //             items[o]['initialTaskId'] != "LastTask") {
  //           readParentTask(items[o]['initialTaskId']);
  //         }
  //       }
  //     } else {}
  //   } catch (e) {
  //     Snacks.errorSnack('During Read initial task : $e');
  //   }
  // }

  //#region property based funcs
  Map<String, dynamic> taskValues(id) {
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
    if (StaticHelpers.homeMiddleAreaType.value == 'now') {
      boxId = 'now';
    }
    data['id'] = id;

    data['boxId'] = boxId;
    data['imgPath'] = imgPath;
    data['boxname'] = boxName;
    data['initialTaskId'] = initialTaskId;
    data['task'] = txtCnt.text;
    data['description'] = description.text;
    data['starting_time'] = fullstartingTime;
    data['pinned_time'] = fullpinnedTime;
    data['importancy'] = importancy.text;
    data['spending_time'] = speningHours;
    data['active'] = isActive;
    data['done_it'] = doneIt;
    data['repeatType'] = type;
    data['weeklyDays'] = weekday;
    data['monthDay'] =
        monthDay.isEmpty ? '' : monthDay.substring(monthDay.length - 2);
    data['finished_time'] = finishedTime;
    data['step'] = step;
    return data;
  }

  setValues(item) {
    clearValues();
    boxId = item['boxId'];
    boxName = item['boxname'];
    initialTaskId = item['initialTaskId'] ?? '';
    txtCnt.text = item['task'];
    description.text = item['description'];
    startingDate.text = item['starting_time'] ??
        item['starting_time'].toString().substring(0, 10);
    startingTime.text = item['starting_time'] ??
        item['starting_time'].toString().substring(11, 16);
    pinnedDate.text =
        item['pinned_time'] ?? item['pinned_time'].toString().substring(0, 10);
    pinnedTime.text =
        item['pinned_time'] ?? item['pinned_time'].toString().substring(11, 16);
    finishedTime = item['finished_time'];
    importancy.text = item['importancy'];
    isActive = item['active'];
    step = item['step'];
    doneIt = item['done_it'];
  }

  setsubValues(item) {
    clearValues();
    boxId = item['boxId'];
    boxName = item['boxname'];
    initialTaskId = item['id'] ?? '';
    startingDate.text = item['starting_time'] ??
        item['starting_time'].toString().substring(0, 10);
    startingTime.text = item['starting_time'] ??
        item['starting_time'].toString().substring(11, 16);
    pinnedDate.text =
        item['pinned_time'] ?? item['pinned_time'].toString().substring(0, 10);
    pinnedTime.text =
        item['pinned_time'] ?? item['pinned_time'].toString().substring(11, 16);
    finishedTime = item['finished_time'];
    importancy.text = item['importancy'];
    isActive = item['active'];
    step = 1;
    doneIt = item['done_it'];
  }

  clearValues() {
    boxId = '';
    boxName = 'choose box';
    initialTaskId = '';
    txtCnt.clear();
    description.clear();

    startingDate.clear();
    startingTime.clear();
    pinnedDate.clear();
    pinnedTime.clear();

    finishedTime = '';
    importancy.text = '1';
    isActive = true;
    doneIt = 0;
    step = 1;

    imgPath = '';
  }

  //#endregion property based funcs

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

  /// delete image from firebase storage
  Future<void> deleteImageFromStorage(String imgUrl) async {
    try {
      // Create a reference to the Firebase Storage file using the image URL
      Reference storageReference = FirebaseStorage.instance.refFromURL(imgUrl);

      // Delete the file
      await storageReference.delete();

      // Image deleted successfully
      print('Image deleted successfully');
    } catch (error) {
      // Handle any errors that occur during the deletion process
      print('Error deleting image: $error');
    }
  }

  //#endregion helpers----------------------------------------------------------

  //#region variables-----------------------------------------------------------

  //#region task properties [14]
  String boxId = '';
  String boxName = 'choose box';
  String initialTaskId = '';
  TextEditingController txtCnt = TextEditingController();
  TextEditingController description = TextEditingController();

  TextEditingController startingDate = TextEditingController();
  TextEditingController pinnedDate = TextEditingController();
  TextEditingController startingTime = TextEditingController();
  TextEditingController pinnedTime = TextEditingController();
  String finishedTime = '';

  TextEditingController importancy = TextEditingController(text: '1');
  bool isActive = true;
  int doneIt = 0;
  int step = 1;
  //#endregion task properties

  /// Базаас [done_it] талбараар хайсан биелэгдээгүй бүх task
  List allUnComlitedTasks = [];

  /// step 1 бүхий бүх task ууд
  List alllightTasks = [];

  /// classified step 1 task list
  RxList lightTasks = [].obs;

  /// thebox дээр task ын бүрэн зураглалыг харуулах [treeview.Node] агуулсан жагсаалт
  RxList<treeview.Node> treeTasks = <treeview.Node>[].obs;

  final ideaCont = Get.find<IdeaStreamCont>();
  String path = '';
  TimeHelper timeHelper = TimeHelper();
  RxBool loadingVis = false.obs;

  RxList completedList = [].obs;
  List completedEntryNames = [];
  RxList dayComplitedTasks = [].obs;

  RxList<Uint8List> boxImg = <Uint8List>[].obs;

  /// зургийн замыг хадаглах str
  String imgPath = '';

  /// sequence repeat type
  String type = '';

  /// хэрвээ 7 хоногоор гэж сонгосон бол давтагдах өдрүүдийн жагсаалт
  List<int> weekday = [];

  /// сараар гэж сонгосон бол сард давтагдах өдөр нь
  String monthDay = '';

  RxList boxList = [].obs;
//#endregion variables----------------------------------------------------------
}
