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

  /// 1. Шаардлагатай үйлдлүүдээ хийгээд task аа хадаглана
  /// 2. Parent task аа шалгаад хэрэгтэй бол update хийнэ.
  createTask(bool movingIn) async {
    try {
      if (txtCnt.text.isNotEmpty) {
        loadingVis.value = true;
        String id = StaticHelpers.id;
        if (boxImg.isNotEmpty) {
          imgPath = await uplodImage(id, txtCnt.text);
        }
        StaticHelpers.databaseReference
            .child('$path/$id')
            .set(taskValues(id))
            .whenComplete(() async {
          readParentTask();
          await readTasks();
          clearValues();
          if (movingIn) {
            ideaCont.deleteIdea(GlobalValues.movingIncomingIdeaId!);
          }
          Snacks.savedSnack();
        });
      }
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  readTasks() async {
    try {
      loadingVis.value = true;
      Query b = StaticHelpers.databaseReference
          .child(path)
          .orderByChild('active')
          .equalTo(
            true,
          );
      DatabaseEvent a = await b.once();
      if (a.snapshot.exists) {
        Map<dynamic, dynamic> data = a.snapshot.value as Map<dynamic, dynamic>;
        activeTasks = data.values.toList();
        List prealllight =
            activeTasks.where((element) => element['step'] == 1).toList();
        alllightTasks.clear();
        boxList.value = activeTasks
            .where((element) =>
                (element['initialTaskId'] == "LastTask" ||
                    element['initialTaskId'] == "") &&
                element['importancy'] == "10")
            .toList();
        for (Map<dynamic, dynamic> child in prealllight) {
          // Check if there is a parent with a matching id
          if (boxList.any((parent) => parent['id'] == child['boxId'])) {
            alllightTasks.add(child);
          }
          if (child['boxId'] == "value") {
            alllightTasks.add(child);
          }
        }

        if (StaticHelpers.homeMiddleAreaType.value == 'allTasks') {
          lightTasks.value = alllightTasks;
          calculateTimeValue(lightTasks);
        } // else if (StaticHelpers.homeMiddleAreaType.value == 'now') {
        //   lightTasks.value = await classifyBoxtasks('now', alllightTasks);
        // } else if (StaticHelpers.homeMiddleAreaType.value == 'outer') {
        //   lightTasks.value = await classifyBoxtasks('', alllightTasks);
        //}
        else {
          // classifyTaskTree(StaticHelpers.homeMiddleAreaType.value);
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
      clearValues();
      Snacks.updatedSnack();
    });
  }

  Future deleteTask(
      String id, String imgpath, String boxid, String initialId) async {
    //initialTaskId bhguu bol neg bol hog bna
    // neg bol box tesk bna
    //box task vgvvg ni shalgaaad hog bol zvgeer ustgachih ni
    // box bol dotor ni bgaa bvh task uudiig bvgdiig ni step neg bolgood outer ruu hiine

    //ustgaj bui item maani ooroo parent vgvvg ni shalgah
    //parent bish bol ooriinh ni parent iig step 1 bolgoh
    //parent bol ooriinh ni parent iin id iig subuudad ni ogoh
    List boxTasks =
        activeTasks.where((element) => element['boxId'] == boxid).toList();
    var subs = checkSubs(id, boxTasks);
    if (subs.isEmpty) {
      //ooriinh ni parent iig step neg bolgoh
    } else {
      //childuudad ni ooriinh ni parentiin id iig initialId aar ogoh
    }
    if (imgpath != '') {
      deleteImageFromStorage(imgpath);
    }
    StaticHelpers.databaseReference.child("$path/$id").remove().then((_) {
      readTasks();
      Get.back();
    });
  }

  //#endregion task CRUD--------------------------------------------------------

  //#region value CRUD----------------------------------------------------------
  createValue() async {
    boxId = 'value';
    try {
      if (txtCnt.text.isNotEmpty) {
        loadingVis.value = true;
        String id = StaticHelpers.id;
        StaticHelpers.databaseReference
            .child('$path/$id')
            .set(taskValues(id))
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
      Query b = StaticHelpers.databaseReference
          .child(path)
          .orderByChild('boxId')
          .equalTo(
            'value',
          );
      DatabaseEvent a = await b.once();
      if (a.snapshot.exists) {
        Map<dynamic, dynamic> data = a.snapshot.value as Map<dynamic, dynamic>;
        lightTasks.value = data.values.toList();
      } else {
        lightTasks.clear();
      }
      loadingVis.value = false;
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
  //#endregion------------------------------------------------------------------

  //#region helpers-------------------------------------------------------------

  Future accomplishTask(String id, String itsboxid, String initId) async {
    try {
      StaticHelpers.databaseReference
          .child('$pathOfAccomplishments/$id')
          .set(taskValues(id))
          .whenComplete(() async {
        deleteTask(id, '', itsboxid, initId);
      });
    } catch (e) {
      print('error $e');
    }
  }

  Future readAllBoxes() async {
    try {
      Query b = StaticHelpers.databaseReference
          .child(path)
          .orderByChild('importancy')
          .equalTo(
            "10",
          );
      DatabaseEvent a = await b.once();
      if (a.snapshot.exists) {
        Map<dynamic, dynamic> data = a.snapshot.value as Map<dynamic, dynamic>;
        allBoxList.value = data.values
            .toList()
            .where((element) =>
                element['initialTaskId'] == "LastTask" ||
                element['initialTaskId'] == "")
            .toList();
      } else {
        allBoxList.clear();
      }
    } catch (e) {
      Snacks.errorSnack('during read all boxes : $e');
    }
  }

  /// 1. [alllightTasks] аас boxId аар нь ялгаж аваад
  /// 2.  calculate хийнэ.
  Future<List<dynamic>> classifyBoxtasks(
      String boxid, List<dynamic> incomingTasks) async {
    List<dynamic> boxTasks = [];
    try {
      boxTasks =
          incomingTasks.where((element) => element['boxId'] == boxid).toList();
      boxTasks = calculateTimeValue(boxTasks);
    } catch (e) {
      Snacks.errorSnack('during classifyBoxtasks $e');
    }
    return boxTasks;
  }

  /// box ийн task уудыг treeview дотор оруулах func
  /// 1. Бүх task уудаас boxid аар нь ялгаж аваад
  /// 2. Эхлээд keyStep үүд буюу тухайн project доторх parent алхамуудыг авна.
  /// 3. давталтаар last step бүр дээр бүрэн угсрагдсан subtask list ийг өнгө
  Future classifyTaskTree(String boxid) async {
    try {
      List boxTasks =
          activeTasks.where((element) => element['boxId'] == boxid).toList();
      List keySteps = boxTasks
          .where((element) =>
              element['initialTaskId'] == boxid ||
              element['initialTaskId'] == '')
          .toList();
      treeTasks.clear();
      for (int i = 0; i < keySteps.length; i++) {
        treeview.Node tasknode = treeview.Node(
            key: 'task',
            label: keySteps[i]['task'],
            data: keySteps[i],
            children: checkSubs(keySteps[i]['id'], boxTasks));
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
    bool thisIsFirstTask = true;
    for (int ii = 0; ii < boxTasks.length; ii++) {
      if (boxTasks[ii]['initialTaskId'] == id) {
        thisIsFirstTask = false;
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
      parentTask['boxId'] = 'now';
    }
    data['id'] = id;

    data['boxId'] = boxId;
    data['imgPath'] = imgPath;
    data['boxname'] =
        parentTask?['boxname'] == "" ? boxName : parentTask?['boxname'];
    data['initialTaskId'] = parentId;
    data['task'] = txtCnt.text;
    data['description'] = descriptionTxt.text;
    data['created_time'] = createdTime.toString().substring(0, 16);
    data['starting_time'] = fullstartingTime;
    data['pinned_time'] = fullpinnedTime;
    data['importancy'] = importancy.text;
    data['spending_time'] = speningHours;
    data['active'] = isActive;
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
    parentTask = item;
    boxId = item['boxId'];
    parentId = item['initialTaskId'];
    txtCnt.text = item['task'];
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
  }

  setsubValues(item) {
    clearValues();
    parentTask = item;
    parentId = item['id'];
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
  }

  clearValues() {
    txtCnt.clear();
    createdTime = DateTime.now();
    parentTask = {};
    startingDate.clear();
    startingTime.clear();
    pinnedDate.clear();
    pinnedTime.clear();
    finishedTime = '';
    importancy.text = '1';
    isActive = true;
    step = 1;
    imgPath = '';
  }

  clearSubValues() {
    txtCnt.clear();
    startingDate.clear();
    startingTime.clear();
    pinnedDate.clear();
    pinnedTime.clear();
    finishedTime = '';
    importancy.text = '1';
    isActive = true;
    step = 1;
    imgPath = '';
  }

  clearParentValues() {
    parentId = '';
    boxId = '';
    boxName = '';
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

  Future readParentTask() async {
    if (parentTask?['step'] == 1 &&
        (parentId != 'LastTask' && parentId != '')) {
      //get individual task
      try {
        //шууд энэ task аа level нэмнэ.
        parentTask['step']++;
        setValues(parentTask);
        updateTask(parentTask['id'], parentTask['imgPath']);
      } catch (e) {
        Snacks.errorSnack('During Read initial task : $e');
      }
    }
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
  String path = '';
  //#region task properties [14]
  // String boxName = 'choose box';
  // String initialTaskId = '';
  String boxId = '';
  String boxName = '';
  var parentTask;
  String parentId = '';
  TextEditingController txtCnt = TextEditingController();
  TextEditingController descriptionTxt = TextEditingController();
  DateTime createdTime = DateTime.now();
  TextEditingController startingDate = TextEditingController();
  TextEditingController pinnedDate = TextEditingController();
  TextEditingController startingTime = TextEditingController();
  TextEditingController pinnedTime = TextEditingController();
  String finishedTime = '';

  TextEditingController importancy = TextEditingController(text: '1');
  bool isActive = true;
  int step = 1;
  //#endregion task properties

  /// Бүх task
  List activeTasks = [];

  /// step 1 бүхий бүх task ууд
  List alllightTasks = [];

  /// classified step 1 task value calculated list
  RxList lightTasks = [].obs;

  /// 🔥 thebox дээр task ын бүрэн зураглалыг харуулах [treeview.Node] агуулсан жагсаалт
  RxList<treeview.Node> treeTasks = <treeview.Node>[].obs;

  final ideaCont = Get.find<IdeaStreamCont>();

  String pathOfAccomplishments = '';
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

  // active үгүү нь хамаагүй бүх box ууд
  RxList allBoxList = [].obs;

//#endregion variables----------------------------------------------------------
}
